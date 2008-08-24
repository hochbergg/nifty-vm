module Sequel
  class Model
    # Creates table.
    def self.create_table
      db.create_table(table_name, @schema)
      @db_schema = get_db_schema(true) unless @@lazy_load_schema
      columns
    end
    
    # Drops the table if it exists and then runs create_table.
    def self.create_table!
      drop_table rescue nil
      create_table
    end
    
    # Drops table.
    def self.drop_table
      db.drop_table(table_name)
    end

    # Returns table schema created with set_schema for direct descendant of Model.
    # Does not retreive schema information from the database, see db_schema if you
    # want that.
    def self.schema
      @schema || (superclass.schema unless superclass == Model)
    end

    # Defines a table schema (see Schema::Generator for more information).
    #
    # This is only needed if you want to use the create_table or drop_table
    # methods.
    def self.set_schema(name = nil, &block)
      set_dataset(db[name]) if name
      @schema = Schema::Generator.new(db, &block)
      set_primary_key(@schema.primary_key_name) if @schema.primary_key_name
    end
    
    # Returns true if table exists, false otherwise.
    def self.table_exists?
      db.table_exists?(table_name)
    end
  end
end
