module NewRelicPing
  class Engine < ::Rails::Engine
    isolate_namespace NewRelicPing

    initializer 'new_relic_ping.add_routes' do
      if NewRelicPing.config.automount?
        Rails.logger.debug do
          "Mounting NewRelicPing::Engine at #{NewRelicPing.config.mountpoint} with mode #{NewRelicPing.config.route_method}"
        end
        Rails.application.routes.public_send(NewRelicPing.config.route_method) do
          mount NewRelicPing::Engine => NewRelicPing.config.mountpoint
        end
      end
    end
  end
end
