$:.push File.expand_path("../lib", __FILE__)
require "getting_started_balloons/version"

Gem::Specification.new do |s|
  s.name        = "getting_started_balloons"
  s.version     = GettingStartedBalloons::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["k1w1"]
  s.email       = ["k1w1@k1w1.org"]
  s.homepage    = "http://github.com/aha-app/getting_started_balloons"
  s.summary     = %q{todo}
  s.description = %q{todo}

  s.files         = Dir["vendor/assets/javascripts/*.js.coffee", "vendor/assets/stylesheets/*.css.less", "lib/getting_started_balloons.rb", "lib/*" "README.md", "MIT-LICENSE"]
  s.require_paths = ["lib"]

  s.add_dependency 'rails'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'coffee-rails'
  s.add_dependency 'd3_rails'
  
end
