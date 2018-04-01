module Haab
  module Controls
    module Inputs
      class Pir < Haab::Controls::Input
        def run
          `gpio -g mode #{pin} down`
          previous_input = 0

          loop do
            input = `gpio -g read #{pin}`.to_i
            if input != previous_input
              fire_action "move #{input == 1 ? 'start' : 'stop'}"
              previous_input = input
            end
            sleep 0.1
          end
        end
      end
    end
  end
end
