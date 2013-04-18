require 'test_helper'

class ConfigurationTest < ActiveSupport::TestCase

  def teardown
    clean_ping_config
  end

  test "initialization" do
    assert NewRelicPing.config.is_a?(NewRelicPing::Configuration), "Should produce config instance without needing configuring first"
  end

  test "setting custom monitors" do
    NewRelicPing.configure do |c|
      c.dummy_setting = 'exists'
      c.monitor('maths') do
        2 + 2
      end
    end

    assert_equal 'exists', current_config.dummy_setting, 'should be able to read/write arbitrary config settings'

    state, results = current_config.status_check
    assert_equal :ok, state
    assert_equal 'true', results['database_response']
    assert_match /\d\.\d+ seconds/, results['database_time']
    assert_equal '4', results['maths_response']
  end

  test "error response" do
    NewRelicPing.configure do |c|
      c.monitor 'flaky-service' do
        raise "service not available"
      end
    end

    state, results = current_config.status_check

    assert_equal :error, state
    assert_equal 'service not available', results['error_message']
  end

  def current_config
    NewRelicPing.config
  end
end
