


module VM
	class Schema < Sequel::Model
		
		def to_json(*args)
			h = {
				:id => "%016x" % @values[:guid],
				:name => @values[:name],
				:preferences => self.prefs,
				:elements => @elements
			}
			
			h.merge!(:viewer => @viewer) if @viewer
			
			h.to_json(*args)
		end
		
		def to_xml
		end
		
		protected
		
		
	end
end