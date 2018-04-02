module Haab
  module Controls
    module Inputs
      class Temperature < Haab::Controls::Input1w
        def run
          loop do
            temp = File.read("/sys/bus/w1/devices/#{w1_device}/w1_slave").split("=").last.to_f / 1000
            publish temp, true
            sleep 300
          end
        end
      end
    end
  end
end
