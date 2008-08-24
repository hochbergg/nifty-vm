require 'oci8'

module Sequel
  module Oracle
    class Database < Sequel::Database
      set_adapter_scheme :oracle
      
      def connect(server)
        opts = server_opts(server)
        if opts[:database]
          dbname = opts[:host] ? \
            "//#{opts[:host]}#{":#{opts[:port]}" if opts[:port]}/#{opts[:database]}" : opts[:database]
        else
          dbname = opts[:host]
        end
        conn = OCI8.new(opts[:user], opts[:password], dbname, opts[:privilege])
        conn.autocommit = true
        conn.non_blocking = true
        conn
      end
      
      def disconnect
        @pool.disconnect {|c| c.logoff}
      end
    
      def dataset(opts = nil)
        Oracle::Dataset.new(self, opts)
      end
    
      def execute(sql, opts={})
        log_info(sql)
        synchronize(opts[:server]) do |conn|
          r = conn.exec(sql)
          yield(r) if block_given?
          r
        end
      end
      alias_method :do, :execute
      
      def tables
        from(:tab).select(:tname).filter(:tabtype => 'TABLE').map do |r|
          r[:tname].downcase.to_sym
        end
      end

      def table_exists?(name)
        from(:tab).filter(:tname => name.to_s.upcase, :tabtype => 'TABLE').count > 0
      end

      def transaction(server=nil)
        synchronize(server) do |conn|
          return yield(conn) if @transactions.include?(Thread.current)
          
          conn.autocommit = false
          begin
            @transactions << Thread.current
            yield(conn)
          rescue => e
            conn.rollback
            raise e unless Error::Rollback === e
          ensure
            conn.commit unless e
            conn.autocommit = true
            @transactions.delete(Thread.current)
          end
        end
      end
    end
    
    class Dataset < Sequel::Dataset
      def literal(v)
        case v
        when OraDate
          literal(Time.local(*v.to_a))
        else
          super
        end
      end

      def fetch_rows(sql, &block)
        execute(sql) do |cursor|
          begin
            @columns = cursor.get_col_names.map {|c| c.downcase.to_sym}
            while r = cursor.fetch
              row = {}
              r.each_with_index {|v, i| row[columns[i]] = v unless columns[i] == :raw_rnum_}
              yield row
            end
          ensure
            cursor.close
          end
        end
        self
      end

      def empty?
        db[:dual].where(exists).get(1) == nil
      end

      # Formats a SELECT statement using the given options and the dataset
      # options.
      def select_sql(opts = nil)
        opts = opts ? @opts.merge(opts) : @opts

        if sql = opts[:sql]
          return sql
        end

        columns = opts[:select]
        select_columns = columns ? column_list(columns) : WILDCARD
        sql = opts[:distinct] ? \
        "SELECT DISTINCT #{select_columns}" : \
        "SELECT #{select_columns}"
        
        if opts[:from]
          sql << " FROM #{source_list(opts[:from])}"
        end
        
        if join = opts[:join]
          join.each{|j| sql << literal(j)}
        end

        if where = opts[:where]
          sql << " WHERE #{literal(where)}"
        end

        if group = opts[:group]
          sql << " GROUP BY #{expression_list(group)}"
        end

        if having = opts[:having]
          sql << " HAVING #{literal(having)}"
        end

        if union = opts[:union]
          sql << (opts[:union_all] ? \
            " UNION ALL #{union.sql}" : " UNION #{union.sql}")
        elsif intersect = opts[:intersect]
          sql << (opts[:intersect_all] ? \
            " INTERSECT ALL #{intersect.sql}" : " INTERSECT #{intersect.sql}")
        elsif except = opts[:except]
          sql << (opts[:except_all] ? \
            " EXCEPT ALL #{except.sql}" : " EXCEPT #{except.sql}")
        end

        if order = opts[:order]
          sql << " ORDER BY #{expression_list(order)}"
        end

        if limit = opts[:limit]
          if (offset = opts[:offset]) && (offset > 0)
            sql = "SELECT * FROM (SELECT raw_sql_.*, ROWNUM raw_rnum_ FROM(#{sql}) raw_sql_ WHERE ROWNUM <= #{limit + offset}) WHERE raw_rnum_ > #{offset}"
          else
            sql = "SELECT * FROM (#{sql}) WHERE ROWNUM <= #{limit}"
          end
        end

        sql
      end

      alias sql select_sql
    end
  end
end
