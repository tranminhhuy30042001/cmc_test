Rails.application.routes.draw do
  post '/signup', to: 'auth#signup'
  post '/login', to: 'auth#login'
  post '/refresh', to: 'auth#refresh'

  get 'orders/:id/download', to: 'orders#download'
  get '/assets', to: 'assets#index'
  post '/assets/bulk_import', to: 'assets#catalog_import'

  resources :orders, only: [:index, :create, :show]

  namespace :admin do
    get 'reports/creators_earnings', to: 'reports#creators_earnings'
  end
end
