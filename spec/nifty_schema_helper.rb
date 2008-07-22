# =SchemaHlper
# Nifty schema helpers
# 
# 

module Nifty
	module Test
		module SchemaHelper
			
			def load_groups_and_schema(*group_names)
				truncate!
				@groups = []
				group_names.each do |name|
					g = Merb::Fixtures::Group[name]
					@groups << g
					g.save! # create models on the db
				end
				
				VM::Schema.load! # load the schema
			end
			
			def unload_schema!
				@groups.each{|x| x.delete!} if @groups
				VM::Schema.unload!
			end
			
			def truncate!
				unload_schema!
				truncate_schema!
				truncate_data!
			end
			
			def truncate_data!
				[App::Entity, App::Fieldlet].each{|m| m.delete}
			end
			
			def truncate_schema!
				VM::Schema.models.each{|m| m.delete}
			end
			
			def load_with_inheritance(klass, *fixtures)
				return nil if fixtures.empty? 
				instances = klass.filter(:id => [klass.fixture(*fixtures)].flatten.collect{|x| x.pk}).all
				
				return nil if instances.empty?
				return instances.first if instances.size == 1 
				return instances
			end
			
			def get_generated_models(generator, generated, *fixtures)
				return nil if fixtures.empty? 
				models = [generator.fixture(*fixtures)].flatten.collect{|x| x.pk}.collect{|id| generated.get_subclass_by_id(id)}
				
				return nil if models.empty?
				return models.first if models.size == 1
				return models
			end
			
			def class_or_superclass_if_inhrited(model)
				raise "#{model} is not Sequel::Model" if not model < Sequel::Model
				model = model.superclass if model.superclass.dataset.polymorphic_key == :kind
				model
			end
			
			def collection_should_be_of_kind_from_fixtures(collection,fixtures_model, fixtures)
				kind_ids = [fixtures_model.fixture(*fixtures)].flatten.collect{|x| x.pk}
				
				kind_ids.size.should <= collection.size
				
				collection.each do |item|
					kind_ids.should include(item.kind)
				end
			end
			
			def collection_should_have_fixture_value(collection, fixtures)
 				model = class_or_superclass_if_inhrited(collection[0].class)
				items = model.fixture(*fixtures)
				
				items.each do |item|
					instance = collection.find{|x| x.pk == item.pk}
					instance.values.should == item.values
				end
			end
			
		end
	end
end