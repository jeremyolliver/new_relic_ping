NewRelicPing::Engine.routes.draw do
  get '/ping'   => 'health#ping'
  get '/health' => 'health#health'
end
