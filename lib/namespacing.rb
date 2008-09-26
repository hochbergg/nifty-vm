# namespacing mixin
#
#
#

module App
	module Namespacing
		def self.included(klass)
			klass.send(:include, InstnaceMethods)
			klass.extend(ClassMethods)
		end
		
		module InstnaceMethods
			# get the current namespace
			def ns()
				@ns ||= self.class::NAMESPACE
			end
		end
		
		module ClassMethods
			# get the current namespace
			def ns()
				self::NAMESPACE
			end
		end
	end
end