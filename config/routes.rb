Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  get '/api/v1/*api/ids', to: 'api_base#ids'
  get '/api/v1/*api', to: 'api_base#index'

end
