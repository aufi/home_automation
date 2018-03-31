require 'mqtt'
require 'yaml'

module Haab
  class App
    attr_reader :config, :bus, :controls

    def initialize(config_path = './haab.yml')
      @config = YAML.load(File.read(config_path))
      @bus = MQTT::Client.connect(@config['bus']['hostname'])
      @controls = []
    end

    def run
      setup_input_controls(@config['input'])
      p controls
    end

    def publish(topic, message, retain = false)
      @bus.publish topic, message, retain
    end

    private

    def setup_input_controls(inputs)
      inputs['button'].each do |input|
        p input
        control = Haab::Controls::Inputs::Button.new(self, input)
        @controls << Thread.start { Thread.current[:control] = control; p control.run }
        sleep 1
        #p control.run
      end
    end
  end
end
