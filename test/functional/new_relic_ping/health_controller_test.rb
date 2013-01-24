require 'test_helper'

module NewRelicPing
  class HealthControllerTest < ActionController::TestCase

    def teardown
      clean_ping_config
    end

    test 'ping' do
      get :ping, use_route: 'new_relic_ping'
      assert_response :success
    end

    test 'health' do
      get :health, use_route: 'new_relic_ping'
      assert_response :success

      assert_equal 'true', @response.header['X-Database-Response'], 'database return value should be present'
      assert_match @response.header['X-Database-Time'], /\d\.\d{6,} seconds/, 'database call time should be present'
    end

    test 'failed health status' do
      NewRelicPing.configure do |c|
        c.monitor('flaky') do
          raise 'this is your friendly failure message'
        end
      end
      get :health, use_route: 'new_relic_ping'

      assert_response :error
      assert_equal 'this is your friendly failure message', @response.header['X-Error-Message']
    end

  end
end
