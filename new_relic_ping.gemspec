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
  s.summary     = "Provides endpoint for NewRelic ping monitoring + capistrano integration"
  s.description = "Provides endpoint for NewRelic ping monitoring + capistrano integration to enable/disable"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.9" # TODO: check compatibility and relax constraint if possible
  s.add_dependency "newrelic_rpm"

  s.add_development_dependency "sqlite3" # TODO: is this required?, add tests
end
