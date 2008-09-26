module App
	class Entities < AppController
	  provides :html, :xml, :js
	  
	  def index
	    @entities = [] #Entity.all_with_fieldlets
	    display @entities
	  end
	  
	  def show
	    @entity = @namespace::Entity.find_with_fieldlets(params[:id])
			raise NotFoundException if !@entity
			display @entity
	  end
	  
	  def new
	    @entity = @namespace::Entity.get_subclass_by_id(params[:id]).new
	    display @entity
	  end
	  
	  def create
	    @entity = @namespace::Entity.get_subclass_by_id(params[:id]).new
			@entity.instances = (params[:entity])
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
			@entity.instances = (params[:entity])
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
	
	
	end
end