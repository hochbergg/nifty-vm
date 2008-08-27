module App
	class Entities < AppController
	  provides :html, :xml, :js
	  
	  def index
	    @entities = [] #Entity.all_with_fieldlets
	    display @entities
	  end
	  
	  def show
	    @entity = Entity.find_with_fieldlets(params[:id])
			display @entity
	  end
	  
	  def new
	    @entity = Entity.get_subclass_by_id(params[:id]).new
	    display @entity
	  end
	  
	  def create
	    @entity = Entity.get_subclass_by_id(params[:id]).new
			@entity.set_fieldlets(params[:entity])
	    if @entity.save_changes
				return render
	    else
	      raise BadRequest
	    end
	  end
	  
	  def edit
	    @entity = Entity.find_with_fieldlets(params[:id])
	    render
	  end
	  
	  def update
	    @entity = Entity.find_with_fieldlets(params[:id])
			@entity.set_fieldlets(params[:entity])
	    if @entity.save_changes
				return render
	    else
	      raise BadRequest
	    end
	  end
	  
	  def destroy
	    @entity = Entity[params[:id]]
	    if @entity.destroy
 				return render
			else
	      raise BadRequest
	    end
	  end
	
	
	
		def search
			entity_dataset = Entity.filter('`display` LIKE ?', "#{params[:search]}%")
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