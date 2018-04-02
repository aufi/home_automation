module Haab
  module Controls
    class Input
      attr_reader :bot, :pin, :topic

      def initialize(bot, options)
        @bot   = bot
        @pin   = options['pin'] || raise('Missing PIN')
        @topic = options['topic'] || raise('Missing topic (ID of control)')
      end

      def run
        raise UnimplementedError
      end

      private

      def fire_action(name, retain = false)
        @bot.publish @topic, name
      end
    end
  end
end
