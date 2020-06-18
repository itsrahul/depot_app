Rails.application.routes.draw do
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
  resources :products do
    get :who_bought, on: :member
  end
  
  resources :support_requests, only: [ :index, :update]

  scope '(:locale)' do
    resources :orders
    resources :line_items
    resources :carts
    root 'store#index',  as: 'store_index'
  end

  namespace :admin do
    resources :reports
    resources :categories
  end
  
end
