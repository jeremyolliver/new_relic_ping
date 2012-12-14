require_dependency "new_relic_ping/application_controller"

module NewRelicPing
  class HealthController < ApplicationController

    def ping
      send_okay
    end

    def health
    end

    protected

    def send_okay(meta_info = {})
      write_headers(meta_info)
      render :text => "OK", :status => :ok
    end

    def send_failure(meta_info = {})
      write_headers(meta_info)
      render :text => "WARNING", :status =>
    end

    def write_headers(values = {})
      values.each do |name, value|
        response.headers[header_name_for(name)] = value
      end
    end

    # Transform :database_response => 'X-Database-Response'
    def header_name_for(name)
      'X' + name.to_s.camelize.gsub(/([A-Z])/) { "-#{$1}"}
    end

  end
end
