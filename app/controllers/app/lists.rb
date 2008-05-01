module App
	class Lists < AppController
	  provides :html, :xml, :js
	  
	  def show
			restful_render List.load(params[:id], :params => params)
	  end
	end
end