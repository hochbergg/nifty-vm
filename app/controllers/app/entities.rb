module App
	class Entities < AppController
	  provides :html, :xml, :js
	  
	  def index
	    @entities = [] #Entity.all_with_fieldlets
	    restful_render @entities
	  end
	  
	  def show
	    @entity = Entity.with_fieldlets(params[:id])
			restful_render @entity
	  end
	  
	  def new
	    @entity = Entity.get_subclass_by_id(params[:id]).new
	    render
	  end
	  
	  def create
	    @entity = Entity.get_subclass_by_id(params[:id]).new
			@entity.set_fieldlets(params[:entity])
	    if @entity.save
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
	    @entity = Entity.with_fieldlets(params[:id])
	    render
	  end
	  
	  def update
	    @entity = Entity.with_fieldlets(params[:id])
			@entity.set_fieldlets(params[:entity])
	    if @entity.save
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
	    @entity = Entity(params[:id])
	    if @entity.destroy
	      redirect url(:entitys)
	    else
	      raise BadRequest
	    end
	  end
	end
end