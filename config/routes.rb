Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # => root
  root to: 'welcome#index'

  get 'admin/merchants/new', to: 'admin/merchants#new', as: :new_merchant

  scope module: 'admin' do
    resources :merchants, only: [:index], as: :admin_merchant, path: '/admin/merchants'
    resource :merchants, only: [:show], as: :admin_merchant_show, path: '/admin/merchants/:id'
    resource :merchants, only: [:create], as: :create_merchant, path: '/merchants'
    resource :merchants, only: [:update], as: :create_merchant, path: '/merchants/:id'
    resource :merchants, only: [:destroy], as: :delete_merchant, path: '/merchants/:id'
    resource :merchant, only: [:edit], path: '/merchants/:id'
  end

  # => admin manipulates a merchants items
  get '/admin/merchants/:merchant_id/items', to: 'admin/items#index', as: :admin_merchant_items
  get 'admin/merchants/:merchant_id/items/new', to: 'admin/items#new', as: :admin_new_item
  get 'admin/merchants/:merchant_id/items/:id/edit', to: 'admin/items#edit', as: :admin_edit_item
  patch 'admin/merchants/:merchant_id/items/:id/edit', to: 'admin/items#update', as: :admin_update_item
  post 'admin/merchants/:merchant_id/items', to: 'admin/items#create', as: :admin_create_item
  post 'admin/merchants/:merchant_id/items/:id/deactivate', to: 'admin/items#deactivate', as: :admin_disable_item
  post 'admin/merchants/:merchant_id/items/:id/activate', to: 'admin/items#activate', as: :admin_enable_item
  delete 'admin/merchants/:merchant_id/items/:id/delete', to: 'admin/items#destroy', as: :admin_delete_item
  patch '/admin/orders/:order_id/items/:id', to: 'admin/items#fulfill', as: :admin_fulfill

  # => merchants
  resources :merchants, only: [:index, :show] do
    resources :items, only: [:index]
  end

  # => items
  resources :items, only: [:index, :show] do
    resources :reviews, only: [:new, :create]
  end

  # => reviews
  resources :reviews, only: [:edit, :update, :destroy]

  # => cart
  get '/cart', to: 'cart#show', as: :cart_path
  post '/cart/:item_id', to: 'cart#add_item'
  delete '/cart', to: 'cart#empty'
  patch '/cart/:change/:item_id', to: 'cart#update_quantity'
  delete '/cart/:item_id', to: 'cart#remove_item'

  # => orders
  resources :orders, only: [:new, :destroy]

  # => users
  resources :users, only: [:create, :show, :edit, :update]

  # => profile
  get '/profile', to: 'users#show', as: :profile
  get '/profile/edit', to: 'users#edit', as: :profile_edit
  patch '/profile/edit', to: 'users#update'

  # => pull up past & current orders for a user
  scope :profile, as: :profile do
    resources :orders, only: [:index, :show, :create]
  end

  # => merchant
  get '/merchant', to: 'merchant/orders#index', as: :merchant_dashboard
  get '/merchant/orders/:id', to: 'merchant/orders#show', as: :merchant_orders
  patch '/merchant/orders/:order_id/items/:id', to: 'merchant/items#fulfill', as: :fulfill

  # => admin
  get '/admin/dashboard', to: 'admin/orders#index', as: :admin_dashboard
  patch '/admin/order/:id', to: 'admin/orders#update', as: :admin_ships_order
  get '/admin/users', to: 'admin/users#index', as: :admin_user_index
  get '/admin/users/:id', to: 'admin/users#show', as: :admin_user_show
  get '/admin/user/:id/edit', to: 'admin/users#edit', as: :admin_user_edit
  patch '/admin/users/:id', to: 'admin/users#update'
  get '/admin/users/:user_id/orders/:order_id', to: 'admin/orders#show', as: :admin_user_order
  delete '/admin/users/:user_id/orders/:order_id', to: 'admin/orders#destroy', as: :admin_cancels_user_order
  patch '/admin/merchants/:id/enable', to: 'admin/merchants#enable', as: :enable_merchant
  patch '/admin/merchants/:id/disable', to: 'admin/merchants#disable', as: :disable_merchant
  patch '/admin/users/:user_id/enable', to: 'admin/users#enable', as: :enable_user
  patch '/admin/users/:user_id/disable', to: 'admin/users#disable', as: :disable_user

  # => user registration & logging in
  get '/register', to: 'users#new', as: :register
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/login', to: 'sessions#destroy'

  get '/dashboard/items', to: 'merchant/items#index', as: :dashboard_items
  get '/dashboard/items/new', to: 'merchant/items#new', as: :new_item
  get '/dashboard/items/:id/edit', to: 'merchant/items#edit', as: :edit_item
  patch '/dashboard/items/:id/edit', to: 'merchant/items#update', as: :update_item
  post '/dashboard/items', to: 'merchant/items#create', as: :create_item
  post '/dashboard/items/:id/deactivate', to: 'merchant/items#deactivate', as: :disable_item
  post '/dashboard/items/:id/activate', to: 'merchant/items#activate', as: :enable_item
  delete '/dashboard/items/:id/delete', to: 'merchant/items#destroy', as: :delete_item

  # => dashboard
  scope :dashboard, as: :dashboard do
    resources :orders, only: :show
  end

  get '*path', to: 'welcome#error404'
end
