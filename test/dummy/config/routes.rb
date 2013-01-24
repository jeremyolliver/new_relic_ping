Rails.application.routes.draw do

  mount NewRelicPing::Engine => "/status"

end
