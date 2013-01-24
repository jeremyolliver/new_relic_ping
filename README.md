NewRelicPing
============

Add a URL to your rails application to respond to ping requests from NewRelic (and other services).
This is something that we've found we often implement. While you can often simply call the root URL
when monitoring, that isn't always possible if the homepage is protected by a login screen which
returns a 403 status. Adding this gem keeps the ping URL's out of your main application space, and
as a bonus, makes additional support for data stores or other services in your heartbeat a breeze.

Usage
-----

Add this to your Gemfile

    gem 'new_relic_ping'

mount in your routes.rb

    mount NewRelicPing::Engine => '/status'
    # Or optionally mount this at an obfuscated url instead
    # mount NewRelicPing::Engine => '/status/5260b194fdea00da7e29b92f54d03028'

This enables two URL's

    /status/ping
    /status/health

ping will respond with the text OK, and status 200 when your rails server is available.
The health action is to allow more deep monitoring of the health of your service. You can configure
additional checks to run when this controller action is hit, this allows you to keep tabs on things
like response times for services or data stores your app is dependent on.

Configuring monitoring checks
-----------------------------

Configure a block to run checks monitoring services you are dependent on, e.g. :

application.rb

    ...
    class Application < Rails::Application

      NewRelicPing.configure do |c|
        # This database check is defined for you by default if you're using ActiveRecord
        # though you can override it by redefining it in your configuration
        c.monitor('database') do
          ActiveRecord::Base.connection.execute("select count(*) from schema_migrations")
        end
        c.monitor('redis') do
          Redis.client.get('test-key')
        end
      end
    ...


These blocks will be executed when the /health action is called, and the additional information set in the HTTP headers of the request.
`X-{service}-Response` will be set to the return value of the block, `X-{Service}-Time` will show the execution time of the given block: "X.XXXXXX seconds".

The return value of the monitoring blocks does not determine success or failure conditions, an HTTP error status will only be returned
if the block raises an exception.

You can now configure any monitoring/alerting tools that you use, such as pingdom, or new relic to 'ping' this url,
checking if your application is alive.

    curl -v http://localhost:3000/status/ping
    curl -v http://localhost:3000/status/health

Planned Features
================

* Capistrano integration for enabling/disabling new relic pinging during deploys
* suggestions welcome

Contributing to NewRelicPing
----------------------------

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

- - -
Copyright (c) 2013 Jeremy Olliver, released under the MIT license
