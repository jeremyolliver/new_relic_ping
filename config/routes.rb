NewRelicPing::Engine.routes.draw do
  get '/'       => 'health#ping'
  get '/health' => 'health#health'
end
