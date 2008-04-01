class Application < Merb::Controller
	
	def restful_render(what)
		case content_type
			when :xml
				return what.to_xml
			when :js
				return what.to_json
			when :html
				return render
		end
	end
	
end