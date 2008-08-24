require File.join(File.dirname(__FILE__), 'spec_helper.rb')

describe "Database schema parser" do
  before do
    INTEGRATION_DB.create_table!(:items){integer :number}
    clear_sqls
  end
  after do
    INTEGRATION_DB.drop_table(:items) if INTEGRATION_DB.table_exists?(:items)
  end

  specify "should be a hash with table_names as symbols" do
    schema = INTEGRATION_DB.schema(nil, :reload=>true)
    schema.should be_a_kind_of(Hash)
    schema.should include(:items)
  end

  specify "should not issue an sql query if the schema has been loaded unless :reload is true" do
    INTEGRATION_DB.schema(nil, :reload=>true)
    clear_sqls
    INTEGRATION_DB.schema
    sqls_should_be
  end

  specify "should give the same result for a single table regardless of whether schema was called for a single table" do
    INTEGRATION_DB.schema(:items, :reload=>true).should == INTEGRATION_DB.schema(nil, :reload=>true)[:items]
  end

  specify "should return the schema correctly" do
    INTEGRATION_DB.create_table!(:items){integer :number}
    schema = INTEGRATION_DB.schema(:items, :reload=>true)
    schema.should be_a_kind_of(Array)
    schema.length.should == 1
    col = schema.first
    col.should be_a_kind_of(Array)
    col.length.should == 2
    col.first.should == :number
    col_info = col.last
    col_info.should be_a_kind_of(Hash)
    col_info[:type].should == :integer
    clear_sqls
    INTEGRATION_DB.schema(:items)
    sqls_should_be
  end
end

describe "Database schema modifiers" do
  before do
    INTEGRATION_DB.create_table!(:items){integer :number}
    @ds = INTEGRATION_DB[:items]
    @ds.insert([10])
    clear_sqls
  end
  after do
    INTEGRATION_DB.drop_table(:items) if INTEGRATION_DB.table_exists?(:items)
  end

  specify "should create tables correctly" do
    INTEGRATION_DB.table_exists?(:items).should == true
    INTEGRATION_DB.schema(:items, :reload=>true).map{|x| x.first}.should == [:number]
    @ds.columns!.should == [:number]
  end

  specify "should add columns to tables correctly" do
    INTEGRATION_DB.schema(:items, :reload=>true).map{|x| x.first}.should == [:number]
    @ds.columns!.should == [:number]
    INTEGRATION_DB.alter_table(:items){add_column :name, :text}
    INTEGRATION_DB.schema(:items, :reload=>true).map{|x| x.first}.should == [:number, :name]
    @ds.columns!.should == [:number, :name]
    unless INTEGRATION_DB.url =~ /sqlite/
      INTEGRATION_DB.alter_table(:items){add_primary_key :id}
      INTEGRATION_DB.schema(:items, :reload=>true).map{|x| x.first}.should == [:number, :name, :id]
      @ds.columns!.should == [:number, :name, :id]
      unless INTEGRATION_DB.url =~ /mysql/
        INTEGRATION_DB.alter_table(:items){add_foreign_key :item_id, :items}
        INTEGRATION_DB.schema(:items, :reload=>true).map{|x| x.first}.should == [:number, :name, :id, :item_id]
        @ds.columns!.should == [:number, :name, :id, :item_id]
      end
    end
  end

  specify "should remove columns from tables correctly" do
    INTEGRATION_DB.create_table!(:items) do
      primary_key :id
      text :name
      integer :number
      foreign_key :item_id, :items
    end
    @ds.insert(:number=>10)
    INTEGRATION_DB.schema(:items, :reload=>true).map{|x| x.first}.should == [:id, :name, :number, :item_id]
    @ds.columns!.should == [:id, :name, :number, :item_id]
    INTEGRATION_DB.drop_column(:items, :number)
    INTEGRATION_DB.schema(:items, :reload=>true).map{|x| x.first}.should == [:id, :name, :item_id]
    @ds.columns!.should == [:id, :name, :item_id]
    INTEGRATION_DB.drop_column(:items, :name)
    INTEGRATION_DB.schema(:items, :reload=>true).map{|x| x.first}.should == [:id, :item_id]
    @ds.columns!.should == [:id, :item_id]
    INTEGRATION_DB.drop_column(:items, :item_id)
    INTEGRATION_DB.schema(:items, :reload=>true).map{|x| x.first}.should == [:id]
    @ds.columns!.should == [:id]
  end
end
