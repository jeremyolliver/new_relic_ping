module NewRelicPing
  class Configuration

    # Default mountpoint for engine
    DEFAULT_MOUNTPOINT = '/heartbeat'
    # used in railtie to read where to mount the engine
    attr_reader :mountpoint

    attr_accessor :monitors

    def initialize(data={})
      @data = {}
      @monitors = {}
      @mountpoint = DEFAULT_MOUNTPOINT
      @mount_mode = :append
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

    # Configure where the engine should be mounted
    def mount_at(mountpoint)
      @mountpoint = mountpoint
    end

    def automount?
      !!@mount_mode
    end

    def route_method
      @mount_mode
    end

    def append_route!
      @mount_mode = :append
    end

    def prepend_route!
      @mount_mode = :prepend
    end

    def dont_mount!
      @mount_mode = nil
    end

    def load_default_monitors
      if defined?(ActiveRecord::Base)
        monitor('database') do
          # Delegate activeness check to actual AR implementation
          # in MySQL it would call mysql.ping in postgres it fallback to SELECT 1
          ActiveRecord::Base.connection.active?
        end
      end
    end

    def status_check
      responses = {}
      begin
        @monitors.each do |label, mon|
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
