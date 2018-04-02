# abstract classes for controls first (ruby 2.5 problem)
Dir['./lib/haab/controls/*.rb'].each{ |f| require f }

# load everything
Dir['./lib/**/*.rb'].each{ |f| require f }

module Haab
  def self.run
    app = Haab::App.new
    app.run
  end
end
