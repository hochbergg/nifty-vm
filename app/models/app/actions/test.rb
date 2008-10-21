require 'app/models/app/action'
module App
  class ActionTest < Action
    register 'print'
    
    def initialize(print, &proc)
      puts "print, sleeping 1 sec"
      sleep 1
      puts print
      puts "print, sleeping 1 sec"
      sleep 1
      proc.call(print) if proc
    end
  end
end