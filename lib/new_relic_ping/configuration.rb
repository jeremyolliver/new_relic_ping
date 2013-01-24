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
      if value.class == Hash
        @data[key.to_sym] = Config.new(value)
      else
        @data[key.to_sym] = value
      end
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
          ActiveRecord::Base.connection.execute("select count(*) from schema_migrations")
        end
      end
    end

    def status_check
      responses = {}
      begin
        @monitors.each do |label, mon|
          return_value = nil
          time = Benchmark.realtime do
            responses["#{label}-Response"] = (mon.call).to_s
          end
          responses["#{label}-Time"] = "#{time.inspect} seconds"
        end
        return :ok, responses
      rescue => e
        return :error, responses
      end
      return :unknown, responses
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
