module Haab
  module Controls
    module Inputs
      class Temperature < Haab::Controls::InputW1
        def run
          `gpio -g mode #{pin} down`
          previous_input = 0

          loop do
            temp = File.read("/sys/bus/w1/devices/#{w1_device}/w1_slave").split("=").last.to_f / 1000
            fire_action 'obyvak/temp', temp, true
            sleep 300
          end
        end
      end
    end
  end
end
