module App
  ##
  # = StepRemoveInstance
  # Removes the instance with the given instance_id
  #
  class StepRemoveInstances < Step  
    register :remove_instances
    param    :instances,       :type => 'Array'
    
    ## 
    # Removes the given instances
    #
    def run!
      instances = @params[:instances]
      instances.each do |instance_id|
		    @entity.instance[instance_id.to_i].mark_for_removal!
		  end
    end
    
  end
end