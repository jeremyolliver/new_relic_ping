module NewRelicPing
  class Configuration

    attr_accessor :monitors

    def initialize(data={})
      @data = {}
      @monitors = {}
      update!(data)
      load_default_monitors
    end

    def update!(data)
      data.each do |key, value|
        self[key] = value
      end
    end

    def [](key)
      @data[key.to_sym]
    end

    def []=(key, value)
      @data[key.to_sym] = value
    end

    def method_missing(sym, *args)
      if sym.to_s =~ /(.+)=$/
        self[$1] = args.first
      else
        self[sym]
      end
    end

    def monitor(label, &block)
      @monitors[label.to_s] = block
    end

    def load_default_monitors
      if defined?(ActiveRecord::Base)
        monitor('database') do
          ActiveRecord::Base.connection.select_values('select 1') == [1]
        end
      end
    end

    def status_check
      responses = {}
      begin
        @monitors.each do |label, mon|
          return_value = nil
          time = Benchmark.realtime do
            responses["#{label}_response"] = (mon.call).to_s
          end
          responses["#{label}_time"] = "#{time.inspect} seconds"
        end
        return :ok, responses
      rescue => e
        responses['error_message'] = e.message
        return :error, responses
      end
    end

  end

  class << self
    attr_accessor :config_instance

    def config
      self.config_instance ||= Configuration.new
    end

    def configure
      yield config
    end
  end

end
