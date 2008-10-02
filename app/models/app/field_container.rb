
module App
  ##
  # = FieldContainer
  # A thin wrapper or cleaner field manipulation and validation
  #
  class FieldContainer
    include Enumerable
    
    
    # accessor for generated errors
    attr_reader :errors
    
    
    ##
    # Intialize the field container
    #
    # @param [Array[App::Field]] fields to be served on the container
    #
    def initialize(fields)
      @fields = {}
      @prefs = {}
      
      fields.each do |field|
        @fields[field::IDENTIFIER] = []
        @prefs[field::IDENTIFIER] = field::PREFS
      end
    end
    
    ##
    # Return the instances of a field
    # 
    # @param [String] hex_field_identifier identifier for the field
    #
    # @return [Array[App::Field]] instances of the given field
    def [](hex_field_identifier)
      @fields[hex_field_identifier]
    end
    
    
    ##
  	# Push the given fieldlet to its field class
  	#
  	# @param [App::Fieldlet] the fieldlet to push
  	#
  	# @return [App::Field] the field which the fieldlet was pushed into
  	# 
  	# === Notes
  	# * The last instance of the fieldlet's field class is chosen
  	#
  	# * If there are no instances for the field class, or the 
  	#   instance_id of the fieldlet is different from the fieldlet's instance_id
  	#   a new field instance will be created.
  	#
  	# * The fieldlet is pushed into the instance (@see Field#push)
  	#
  	# * We assume that all the fieldlets are order by the instance_id, 
  	#   so when the instance_id changes, we KNOW that we should move
  	#   to another instance
  	#
  	def push(fieldlet)
  		field = @fields[fieldlet.class::FIELD_ID].last
  		if field && field.instance_id == fieldlet[:instance_id]
  			return field << fieldlet
  		end 
    
  		field = fieldlet.class::FIELD.new(self)
  		field << fieldlet
    
  		@fields[fieldlet.class::FIELD_ID] << field
    
      return field
  	end
  	
  	
  	##
  	# Each method for using with the Enumerable mixin
  	#
  	#
    def each(&block)
      @fields.each(&block)
    end
  
    ##
    # checks if the fields are valid
    #
    # @return [Boolean] true if all the fields are valid
    def valid?
      @errors = []
      
      validate_instance_numbers!
      
      @errors.empty? 
    end
    
    ##
    # Checks if there are no instances for any field
    #
    # @return [Boolean] true if there are no instances
    def empty?
      @fields.values.empty?
    end
    
    ##
    # Saves the all the fields
    #
    # @return [Hash{String=>Array[App:Field]}] the fields
    #
    def save
      @fields.each do |field_id, instances|
        instances.each{ |instance| instance.save}
      end
    end
    
    protected
    
    def validate_instance_numbers!
      @prefs.each do |field_id, prefs_hash|
        validate_minimum!(field_id, prefs_hash)
        validate_maximum!(field_id, prefs_hash)
      end
    end
    
    def validate_minimum!(field_id, prefs_hash)
       if extract_from_prefs(prefs_hash['minInstance']) > @fields[field_id].size
            @errors << {:id => field_id, :error => :min}
        end
    end
    
    def validate_maximum!(field_id, prefs_hash)
       if extract_from_prefs(prefs_hash['maxInstance']) < @fields[field_id].size
            @errors << {:id => field_id, :error => :max}
        end
    end
    
    
    def extract_from_prefs(value)
      return nil if !value
      value = value.to_i
      return false if value == 0
      return value
    end
    
    
  end
end