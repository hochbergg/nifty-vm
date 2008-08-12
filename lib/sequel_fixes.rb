# utility fixes for sequel_model

module Sequel
	class Model
		 def refresh
				return self if @new # fix for not reloading stright after update
	      @values = this.first || raise(Error, "Record not found")
	      @associations.clear
	      self
	    end
	end
end

# adding support for composite_primary_key in schema

module SequelFixes
		module GeneratorFixes
			
			# compossite primary key 
			def composite_primary_key(*key)
				@composite_primary_key = key
			end
			
			# The name of the primary key for this table, if it has a primary key.
      def primary_key_name
				return @composite_primary_key if @composite_primary_key
        @primary_key[:name] if @primary_key
      end

			# Return the DDL created by the generator as a array of two elements,
      # the first being the columns and the second being the indexes.
      def create_info
				@extras = []
				@extras = [{:composite_primary_key => @composite_primary_key}]  if @composite_primary_key
        @columns.unshift(@primary_key) if @primary_key && !has_column?(primary_key_name)
        [@columns, @indexes, @extras]
      end
		end
end


	module SequelFixes
		module SqlFixes
			 # Array of SQL DDL statements, the first for creating a table with the given
	      # name and column specifications, and the others for specifying indexes on
	      # the table.
	      def create_table_sql_list(name, columns, indexes = nil,extra = nil)
					extra_sql = extra ? "#{COMMA_SEPARATOR}#{extra_list_sql(extra)}" : ''
	        sql = ["CREATE TABLE #{quote_identifier(name)} (#{column_list_sql(columns)}#{extra_sql})"]
	        sql.concat(index_list_sql_list(name, indexes)) if indexes && !indexes.empty?
	        sql
	      end
	
				def extra_list_sql(extra_list)
					if keys = extra_list.first[:composite_primary_key]
						return "#{PRIMARY_KEY} (#{keys.collect{|k| quote_identifier(k)}.join(COMMA_SEPARATOR)})"
					end
				end
		end
	end

#Sequel::Schema::Generator.send(:include, SequelFixes::GeneratorFixes)

#Sequel::Database.send(:include, SequelFixes::SqlFixes)
