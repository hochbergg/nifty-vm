module Merb
  module GlobalHelpers
    # helpers defined here available to all views.  

		
		# include tag for ext. if caching is on, using the minified ext version. 
		# else, using ext-debug
		def ext_js_include_tag
			ext = 'ext-all'
			#ext = 'ext-all-debug' unless ActionController::Base.perform_caching #caching is on
			js_include_tag('../ext/ext-base', "../ext/#{ext}", :bundle => 'ext')
		end

		def ext_css_include_tag
			css_include_tag('../ext/resources/css/ext-all.css', :bundle => 'ext')
		end
  end
end
