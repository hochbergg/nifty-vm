


module VM
	class Schema < Sequel::Model
		
		def to_json
			h = {
				:id => @values[:guid].to_s(16),
				:name => @values[:name],
				:preferences => self.prefs,
				:elements => @elements
			}
			
			h.merge!(:viewer => @viewer) if @viewer
			
			h.to_json
		end
		
		def to_xml
		end
		
		protected
		
		
	end
end