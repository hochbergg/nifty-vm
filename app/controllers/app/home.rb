# App base controller

module App
	
	class Home < AppController
		def index
			fix_path() if request.uri[-1,1] != '/'
			render
		end
		
		def fix_path
			return redirect('/') if(!params[:directory])
			return redirect("/#{params[:directory]}/")
		end
	end
end