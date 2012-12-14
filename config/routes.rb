NewRelicPing::Engine.routes.draw do
  get '/ping'   => 'monitor#ping'
  get '/health' => 'monitor#health'
end
