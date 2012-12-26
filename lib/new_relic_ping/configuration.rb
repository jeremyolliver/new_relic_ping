module NewRelicPing
  class Configuration

    attr_accessor :config
    cattr_reader :config_instance

    def initialize
      @config = HashWithIndifferentAccess.new
    end

    def self.get_instance
      @@config_instance ||= NewRelicPing::Configuration.new
    end

    def self.configure(&block)
      yield get_instance
      get_instance
    end

    def method_missing(meth, *params)
      config_option = meth.to_s.gsub(/\W/, '')
      @config[config_option] = *params
    end

  end
end
