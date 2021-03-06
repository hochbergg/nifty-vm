module App
	class Entities < AppController
	  provides :xml, :json
	  layout false # no layouts
	  
	  def index
	    @entities = [] #Entity.all_with_fieldlets
	    display @entities
	  end
	  
	  def show
	      @entity = @namespace::Entity.find_with_fieldlets(params[:id])
			  raise NotFoundException if !@entity
			  set_last_modified_headers()
			  display @entity
	  end
	  
	  def new
	    @entity = @namespace::Entity.get_subclass_by_id(params[:id]).new
	    @entity.apply_constructor!
	    apply_actions!
	    display @entity
	  end
	  
	  def create
	    @entity = @namespace::Entity.get_subclass_by_id(params[:id]).new
	    apply_actions!
	    if @entity.save_changes
				return render
	    else
	      raise BadRequest
	    end
	  end
	  
	  def edit
	    @entity = @namespace::Entity.find_with_fieldlets(params[:id])
	    render
	  end
	  
	  def update
	    @entity = @namespace::Entity.find_with_fieldlets(params[:id])
	    apply_actions!
	    if @entity.save_changes
				return render
	    else
	      raise BadRequest
	    end
	  end
	  
	  def destroy
	    @entity = @namespace::Entity[params[:id]]
	    if @entity.destroy
 				return render
			else
	      raise BadRequest
	    end
	  end
	
	
	
		def search
			entity_dataset = @namespace::Entity.filter('`display` LIKE ?', "#{params[:search]}%")
			entity_dataset.filter!(:kind => params[:kind]) if params[:kind]
			entity_dataset.limit!(30)
			
			@entities = entity_dataset.all
			return {
				:entities => @entities,
				:total => @entities.size
			}.to_json
		end
		
		
    protected
    
    ##
    # Sets the last modified headers for the entity
    #
	  def set_last_modified_headers
	   # turned off due to weird FF3 bug
	   #self.headers['Last-modified'] = @entity[:updated_at].httpdate 
	  end
	  
	
	  ##
	  # queues the async actions of the current @entity, if given
	  #
	  def set_async_actions!
	    return if !@entity.async_actions
	    
	    async_actions.each do |async_proc|
	      run_later(&async_proc)
      end
	  end
	  
	  ##
	  # a shortcut to applying actions on the currently loaded entity
	  def apply_actions!
	    @entity.apply_actions!(params[:entity])
			set_async_actions!
    end
	end
end