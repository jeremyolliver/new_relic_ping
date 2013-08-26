$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "new_relic_ping/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "new_relic_ping"
  s.version     = NewRelicPing::VERSION
  s.authors     = ["Jeremy Olliver"]
  s.email       = ["jeremy.olliver@gmail.com"]
  s.homepage    = "https://github.com/jeremyolliver/new_relic_ping"
  s.summary     = "Rails endpoint for NewRelic HTTP ping monitoring"
  s.description = "Provides endpoint for NewRelic HTTP ping monitoring for Rails applications"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md", "CHANGELOG.md"]
  s.test_files = Dir["test/**/*"]
  s.license = "MIT"

  s.add_dependency "rails", "~> 3.2" # Relaxed version constraint, we don't want to be a barrier to upgrading
  # s.add_dependency "newrelic_rpm"
end
