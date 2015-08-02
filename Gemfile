source 'https://rubygems.org'

# Declare your gem's dependencies in new_relic_ping.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

group :development, :test do
  gem 'coveralls', :require => false
  # gem "pry" # Note: debugger etc don't install on jruby and rubinius

  # for CRuby, Rubinius, including Windows and RubyInstaller
  gem 'sqlite3', :platform => [:ruby, :mswin, :mingw]

  # JRuby support
  gem 'jdbc-sqlite3', :platform => :jruby
  gem 'activerecord-jdbcsqlite3-adapter', :platform => :jruby

  # Rubinius support
  platforms :rbx do
    gem 'racc'
    gem 'rubysl', '~> 2.0'
    gem 'psych'
  end
end

# jquery-rails is used by the dummy application
gem 'jquery-rails'
