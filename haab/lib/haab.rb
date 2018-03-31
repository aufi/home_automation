Dir['./lib/**/*.rb'].each{ |f| require f }

module Haab
  def self.run
    app = Haab::App.new
    app.run
  end
end
