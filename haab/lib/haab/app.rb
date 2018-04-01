require 'mqtt'
require 'yaml'

module Haab
  class App
    attr_reader :config, :bus, :controls, :semaphore_bus

    def initialize(config_path = './haab.yml')
      @config = YAML.load(File.read(config_path))
      @bus = MQTT::Client.connect(@config['bus']['hostname'])
      @controls = []
      @semaphore_bus = Mutex.new
    end

    def run
      setup_input_controls(@config['input'])
      loop do
        puts Time.now
        p @controls
        sleep 60
      end
    end

    def publish(topic, message, retain = false)
      @semaphore_bus.synchronize do
        @bus.publish topic, message, retain
      end
    end

    private

    def setup_input_controls(inputs)
      inputs.each do |category, inputs|
        control_class = Object.const_get("Haab::Controls::Inputs::#{category.capitalize}")
        inputs.each do |input|
          control = control_class.new(self, input)
          @controls << Thread.start { Thread.current[:control] = control; p control.run }
        end
      end
    end
  end
end
