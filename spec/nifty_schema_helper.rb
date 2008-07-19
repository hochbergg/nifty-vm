# =SchemaHlper
# Nifty schema helpers
# 
# 

module Nifty
	module Test
		module SchemaHelper
			
			def load_groups_and_schema(*group_names)
				@groups = []
				group_names.each do |name|
					g = Merb::Fixtures::Group[name]
					@groups << g
					g.save! # create models on the db
				end
				
				VM::Schema.load! # load the schema
			end
			
			def unload_schema!
				@groups.each{|x| x.delete!}
				VM::Schema.unload!
			end
			
			def load_with_inheritance(klass, *fixtures)
				return [] if fixtures.empty? 
				instances = klass.filter(:id => klass.fixture(*fixtures).to_a.collect{|x| x.pk}).all
				
				return instances.first if instances.size == 1 
				return instances
			end
			
			def get_generated_models(generator, generated, *fixtures)
				return [] if fixtures.empty? 
				models = generator.fixture(*fixtures).to_a.collect{|x| x.pk}.collect{|id| generated.get_subclass_by_id(id)}
				
				return models.first if models.size == 1
				return models
			end
		end
	end
end