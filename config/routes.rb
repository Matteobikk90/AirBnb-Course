Rails.application.routes.draw do

  root 'pages#home'

  devise_for  :users, 
              :path => '', 
              :path_names => {:sign_in => 'login', :sign_out => 'logout', :edit => 'profile'},
              :controllers => {:omniauth_callbacks => 'omniauth_callbacks',
                               :registrations => 'registrations'
                              }

  resources :users, only: [:show]
  resources :rooms
  resources :photos

  resources :rooms do
  resources :bookings, only: [:create]
  end

  get '/preload' => 'bookings#preload'
  get '/preview' => 'bookings#preview'
  get 'your_trips' => 'bookings#your_trips'
  get 'your_bookings' => 'bookings#your_bookings'

end
