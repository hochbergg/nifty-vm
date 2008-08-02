# must load namespaces
require 'namespaces'
require 'inheritance_mixin'


module App
	class Entity < Sequel::Model
		# = Entity
		#
		# The base Entity model, used by NiftyVM
		#
		# * Entities used the InheritanceMixin for STI
		# * Entity's subclasses are generated by the EntityKind model on Schema load
		#
		#
		# = Architecture
		# *	Entity 
		#    + Fields
		# 	 + Fieldlets	
		#
		# == Fields
		# A Field is a set of 1 or more instances, and a solid definition of it's fieldlets
		# 	Every FieldInstnace has the Fieldlets acording to the definition in the field
		#
		# == Fieldlets
		# Fieldlet is the smallest piece of information that can be store in an entity
		# Simple examples of fieldlets are: String, Text, File, Date etc
		# 
		# For more information about entities, checkout entity's included modules
		
		
		# Force the dataset - will force the dataset on all the subclasses
		# (so Entity1 will use the `entities` table instead of `entities1`)
		set_dataset self.db[:entities]
		
		# set schema
		set_schema do 
			primary_key :id
			int					:kind
			datetime		:created_at
			datetime		:updated_at
			varchar			:display, :size => 255

			index				[:kind, :display]
			index				[:display]
		end
		
		# Inheritance Mixin - for smart STI
		include InheritanceMixin
		
	end
end