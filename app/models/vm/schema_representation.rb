


module VM
	class Schema < Sequel::Model
		
		def to_json
			elements_hash = {}
			@elements.each do |k,v|
				elements_hash.merge!({k.to_s => v})
			end
			
			h = {
				:id => @values[:guid].to_s(16),
				:name => @values[:name],
				:preferences => self.prefs,
				:elements => elements_hash
			}
			
			h.merge!(:viewer => @viewer) if @viewer
			
			h.to_json
		end
		
		def to_xml
		end
		
		protected
		
		
	end
end