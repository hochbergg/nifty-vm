module App
  ##
  # = StepUpdateInstance
  # Updates the entity with the field
  #
  class StepPrint < Step  
    register :print
    param    :what, :type => 'String'
    
    ## 
    # Updates the given instance id with the given instances_hash
    #
    #
    #
    def run!
			puts @params[:what]
    end
    
  end
end