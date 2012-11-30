Rails.application.routes.draw do

  mount NewRelicPing::Engine => "/new_relic_ping"
end
