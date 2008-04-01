# must load namespaces
require 'namespaces'
require 'inheritance'

# load all entity models
Dir.glob(Merb.root / 'app'/ 'models' / 'app' / 'entity' / '*.rb').each{|f| require f}


module App
	class Entity < Sequel::Model
		set_dataset self.db[:entities]
		include Inheritance
		
		# include modules:
		include EntityDataManipulation
		include EntityActions
		include EntityLinks
		include EntityRepresentation
		include EntitySecurity
		include EntityTriggers
		
	end
end