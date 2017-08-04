Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/api/v1/*api/schema', to: 'api_base#schema'
  get '/api/v1/*api/ids', to: 'api_base#ids'
  get '/api/v1/*api/perform/:action_name', to: 'api_base#perform'
  get '/api/v1/*api', to: 'api_base#index'

end
