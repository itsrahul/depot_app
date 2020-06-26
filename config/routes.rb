Rails.application.routes.draw do
  root 'store#index',  as: 'store_index'
  
  # constraints(-> (req) { !req.env['HTTP_USER_AGENT'].include?("Firefox") }) do
  constraints(-> (req) { req.env['HTTP_USER_AGENT'].include?("Firefox") }) do
    get 'admin' => 'admin#index'
    controller :sessions do
      get 'login' => :new
      post 'login' => :create
      delete 'logout' => :destroy
    end
    get 'sessions/create'
    get 'sessions/destroy'

    resources :users do
      collection do
        get :orders
        get :line_items
      end
    end
    resources :products, path: :books do
      get :who_bought, on: :member, format: 'atom'
      get :rate, on: :member
    end
    
    resources :support_requests, only: [ :index, :update]

    scope '(:locale)' do
      resources :orders
      resources :line_items
      resources :carts
      get 'my-orders', to: 'users#orders'
      get 'my-items', to: 'users#line_items'
      get 'categories/:id', to: 'store#index', constraints: { id: /\D.+/ }
      # root 'store#index',  as: 'store_index'
    end

    namespace :admin do
      resources :reports, only: :index
      resources :categories, only: [:index, :show]
    end

    resources :categories do
      resources :products, path: :books
    end
  end
end
