module Haab
  module Controls
    class Input1w
      attr_reader :bot, :w1_device, :topic

      def initialize(bot, options)
        @bot       = bot
        @w1_device = options['w1_device'] || raise('Missing w1_device')
        @topic     = options['topic'] || raise('Missing topic (ID of control)')
      end

      def run
        raise UnimplementedError
      end

      private

      def publish(name, retain = false)
        @bot.publish @topic, name, retain
      end
    end
  end
end
