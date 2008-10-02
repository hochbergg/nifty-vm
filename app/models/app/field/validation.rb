module App
	class Field
		attr_reader :errors
		
		##
		# Validates the field instance
		#
		# @return [Boolean] true if the field is valid, false if not
		# 
		# === Notes
		# * All the validation errors are pushed into the @errors var
		# 
		def valid?
		  @errors = []
			validate_fieldlets!
		
		  return @errors.empty?
		end
	 
    ##
    # Validates the instance's fieldlets
    #
    #
	  def validate_fieldlets!
	    
    end 
	  
	end
end