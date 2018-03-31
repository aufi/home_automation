module Haab
  module Controls
    module Inputs
      class Button
        attr_reader :bot, :pin, :topic

        def initialize(bot, options)
          @bot   = bot
          @pin   = options['pin'] || raise('Missing PIN')
          @topic = options['topic'] || raise('Missing topic (ID of control)')
        end

        def run
          # pull initial up state
          `gpio -g mode #{pin} up`

          previous_input = 1
          last_up_at, last_down_at = Time.now

          loop do
            input = `gpio -g read #{pin}`.to_i
            if previous_input == 1 && input == 0
              fire_action "DOWN"
              last_down_at = Time.now
            elsif previous_input == 0 && input == 1
              fire_action "UP"
              last_up_at = Time.now
              duration = last_up_at - last_down_at
              if duration < 0.5
                fire_action "CLICK"
              elsif duration < 2
                fire_action "LONG_CLICK"
              else
                fire_action "EXTRA_LONG_CLICK"
              end
            end
            previous_input = input
            sleep 0.1
          end
        end

        private

        def fire_action(name)
          @bot.publish @topic, name
        end
      end
    end
  end
end
