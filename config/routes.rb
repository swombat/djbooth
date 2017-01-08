Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#index'

  get '/stream/:index', to: 'application#stream'
  post '/nogood', to: 'application#nogood'
  post '/rename', to: 'application#rename'
  post '/keepname', to: 'application#keepname'
end
