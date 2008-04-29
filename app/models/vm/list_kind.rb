module VM
	class ListKind < ::Sequel::Model
		include ModelBuildTools
		include PreferencesTools

		
		def build_model_extention			
			<<-CLASS_DEF
					def kind
						#{self.id}
					end
			CLASS_DEF
		end
		
	end
end
