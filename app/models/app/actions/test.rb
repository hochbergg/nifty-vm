require 'app/models/app/action'
module App
  class ActionTest < Action
    register 'print'
    
    def initialize(print, &proc)
      proc.call if proc
    end
  end
end