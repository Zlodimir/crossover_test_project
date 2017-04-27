Rails.application.routes.draw do
  default_url_options host: 'localhost:3000'
  root 'pages#index'

  get '/api/orders/:id/success_callback/:token', to: 'api/orders#success_callback', as: 'success_callback_api_order'
  get '/api/orders/:id/reject_callback/:token', to: 'api/orders#reject_callback', as: 'reject_callback_api_order'

  mount_devise_token_auth_for 'Customer', at: 'api/auth'
  namespace :api, defaults: { format: :json } do
    resources :orders, only: [:create, :index, :show] do
      put :payment, on: :member
    end
    resources :products
  end
end
