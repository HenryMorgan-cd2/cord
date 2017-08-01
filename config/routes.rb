Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  get '/api/v1/articles', to: 'api_base#index'
  get '/api/v1/articles/ids', to: 'api_base#ids'

end
