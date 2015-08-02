require 'test_helper'

module NewRelicPing
  class HealthControllerTest < ActionController::TestCase

    def setup
      @routes = NewRelicPing::Engine.routes
    end

    def teardown
      clean_ping_config
    end

    test 'ping' do
      get :ping
      assert_response :success
    end

    test 'health' do
      get :health
      assert_response :success

      assert_equal 'true', @response.header['X-Database-Response'], 'database return value should be present'
      assert_match /[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)? seconds/, @response.header['X-Database-Time'], 'database call time should be present'
    end

    test 'failed health status' do
      NewRelicPing.configure do |c|
        c.monitor('flaky') do
          raise 'this is your friendly failure message'
        end
      end
      get :health

      assert_response :error
      assert_equal 'this is your friendly failure message', @response.header['X-Error-Message']
    end

  end
end
