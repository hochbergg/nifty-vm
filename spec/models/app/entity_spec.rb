require File.join( File.dirname(__FILE__), "..", '..', "spec_helper" )

describe App::Entity do

	# do before
	before(:each) do
		set_fixtures # setup fixtures
	end

	it "should determine the class when fetching" do
		entities(:entity_with_kind_1).class.should be(App::Entity1)
	end
	
	it "should fetch many entities and get different classes" do
		classes = [App::Entity1]
		
		(classes & App::Entity.all.collect{|e| e.class}.flatten) == classes
	end


	it "should create fieldlets for entity"

	it "should update fieldlets for entity"
	
	it "should save fieldlets and entity in the same transaction"
	
	it "should rollback when fieldlet saving is bad"
	

end