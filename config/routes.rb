Rails.application.routes.draw do
  root                'static_pages#home'
  get 'help'       => 'static_pages#help'
  get 'about'      => 'static_pages#about'
  get 'team'       => 'static_pages#team'
  get 'signup'     => 'users#new'
  get 'login'   => 'sessions#new'
  post 'users/remote' => 'sessions#create_remote'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :teams
  patch 'team.:id' => 'teams#update'
  resources :pages,               only: [:new, :create, :edit, :update,
                                         :destroy]
  resources :articles

  get 'teams/:id/leave'  => 'teams#leave'

  get 'invites/send'    => 'teams#send_invite'
  get 'invites/cancel'  => 'teams#cancel_invite'
  get 'invites/accept'  => 'teams#accept_invite'
  get 'invites/decline' => 'teams#decline_invite'

  get '/:id' => 'pages#show'
end
