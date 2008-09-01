# utility fixes for sequel_model

module Sequel
	class Model
		 def refresh
				return self if @new # fix for not reloading stright after update
	      @values = this.first || raise(Error, "Record not found")
	      @associations.clear
	      self
	    end
	end
end
