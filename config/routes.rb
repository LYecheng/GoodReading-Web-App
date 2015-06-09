Rails.application.routes.draw do
 
  root 'books#index'


  get '/login' => 'sessions#new'
  post '/sessions' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/history/clear' => 'history#destroy' 

  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  get '/users/reset_password' => 'users#reset_password'
  post '/users/reset_password' => 'users#send_password'
  get '/users/change_password/:id' => 'users#edit'
  patch '/users/change_password/:id' => 'users#update'
  get '/users/:id' => 'users#show', as: :user
  

  resources :books
  resources :authors

  get '/favorites/:id/add' => 'books#add_favorite'
  get '/favorites/:id/delete' => 'books#remove_favorite'

end
