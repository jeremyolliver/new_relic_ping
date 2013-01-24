require_dependency "new_relic_ping/application_controller"

module NewRelicPing
  class HealthController < ApplicationController

    # Return an okay if the Application Server is alive
    def ping
      send_response(:ok)
    end

    # Run the configured monitoring blocks
    # Set the response times (return values) as HTTP headers
    # return either ok or error status (error sent only if the configured block raises an exception)
    def health
      send_response(*configuration.status_check)
    end

    protected

    def send_response(status_msg, meta_info = {})
      write_headers(meta_info)
      render :text => status_msg.to_s, :status => status_msg, :content_type => Mime::TEXT
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

    private

    def configuration
      NewRelicPing.config
    end

  end
end
