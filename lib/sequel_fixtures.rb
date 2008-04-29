module Sequel
	# = Sequel Fixtures
 	#  A simple fixtures system, for loading data to the db from yaml files 
	#  into the db
	#
	
	
	# = Sequel Fixture
	#  Loader of fixtures
	#  
	#  == Usage
	#  Fixture.new(:entities).commit! => cleans the entities table, and load data into the db
	
	
	class Fixture
		attr_accessor :db, :table, :path
		
		def initialize(table, path = nil, db = Merb::Orms::Sequel.connect)
			@table = table
			@db = db
			@path = path || generate_path_from_table_name
		end
		
		
		# load the data from the yaml file
		def commit
			@hash = Erubis.load_yaml_file(@path)
			
			@hash.values.each do |item|
				@db[@table] << item
			end
			
			# return the data hash for caching
			return @hash
		end


		# clean the table 
		def clean
			@db[@table].delete
		end
		
		
		def commit! 
			clean
			commit
		end
		
		protected
		
		# generate load path from the table
		def generate_path_from_table_name
			"#{Merb.root}/spec/fixtures/#{@table}.yml"
		end
		
	end
	
	
	# = Model Fixture
	# used as same as normal Fixture, only creates model, 
	# and fills it with given data via create_from_params
	# TODO: Change to from create_from_params
		
	class ModelFixture < Fixture
		def initialize(model, path = nil)
			# init basic fixture
			super(model.dataset.opts[:from], path, model.db) 
			@model = model
		end
		
			
		def commit
			@hash = Erubis.load_yaml_file(@path)
			return {} unless @hash
			
			@for_cache = {}
			@hash.each do |key, value_hash|
				# UGLY!
				if @model.modules.include? InheritanceMixin
					@for_cache[key] = @model.create_with_kind(value_hash) 
				else	
					@for_cache[key] = @model.create(value_hash) 
				end
			end
			
			return @for_cache
		end
	end
	
	
	
	# 
	#
	#
	#
	class Fixtures
		cattr_accessor :cache
		def self.load!
			@@cache = {}
			Dir.glob(Merb.root / 'spec' / 'fixtures'/ '*.yml') do |path|
				table_name = path.split('/').last.sub('.yml', '').to_sym
				begin
					if model = self.has_sequel_model?(table_name)
						@@cache[table_name] = ModelFixture.new(model, path).commit!
					else      
						@@cache[table_name] = Fixture.new(table_name, path).commit!
					end
				rescue 
					puts "Error inserting #{table_name}"
				end		
			end
			return @@cache
		end
		
		def self.[](key)
			self.get(key)
		end
		
		# get fixture table hash from cache
		def self.get(table_name)
			@@cache[table_name]
		end
		
		# return all keys for fixture tables
		# (will be used with the spec helper)
		def self.tables
			@@cache.keys
		end
		
		private
		def self.has_sequel_model?(table_name)
			namespaces = [App,Object,VM]
			
			model_name = Inflector.singularize(table_name.to_s.camelize)
			
			namespaces.each do |ns|
					if ns.const_defined?(model_name)
						m = ns.const_get(model_name)
						return m if m.respond_to? :dataset #is a sequel model
					end
			end
			
			return false
		end
	end
end