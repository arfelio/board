Board::Application.routes.draw do
  resources :categories

  resources :advertisements
  resources :comments

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "registrations" }, :path_prefix => 'my'
  #get "users/profile"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  get 'users/show', as: 'user_root'
  # You can have the root of your site routed with "root"
  root 'advertisements#index'
 # get "persons/index"
  #get "persons/edit"
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  #get "admin/users/index"
#scope '/admin' do
  resources :users
#end

  
end
