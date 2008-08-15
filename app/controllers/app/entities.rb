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
				if params[:format] == 'js'
					render
				else
	      	redirect url(:entity, @entity)
				end
	    else
	      render :action => :new
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
				if params[:format] == 'js'
					render
				else
	      	redirect url(:entity, @entity)
				end
	    else
	      raise BadRequest
	    end
	  end
	  
	  def destroy
	    @entity = Entity[params[:id]]
	    if @entity.destroy
	      redirect url(:entities)
	    else
	      raise BadRequest
	    end
	  end
	end
end