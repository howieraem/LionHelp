Rails.application.routes.draw do
  # resources :posts  # this is useless if post_controller.rb does not exist under app/controllers (not app/controllers/api)
  namespace :api do
    namespace :v1 do
      get 'posts/index/:search/:location/:sort',to: 'posts#index'
      get 'posts/cur_posts'
      get 'posts/pre_posts'
      get 'posts/help_history'
      get 'posts/help/:id', to: 'posts#help'
      get 'posts/cancel'
      get 'posts/complete'
      get 'posts/complete2'
      post 'posts/comment'
#      get 'posts/comment_list'
#      get 'posts/comment', to: 'posts#comment', as: :get_post_comment
      post 'posts/create'
      get 'posts/show/:id', to: 'posts#show'
      delete 'posts/destroy/:id', to: 'posts#destroy'
      put 'posts/update/:id', to: 'posts#update'

      get 'auth', to: 'users#get_cur_usr', as: :get_cur_usr
      get 'users/:id', to: 'users#get'
      put 'users/:id', to: 'users#edit_profile', as: :edit_profile
      post 'signup', to: 'users#create'
      post 'login', to: 'users#login'
    end
  end
  root 'homepage#index'
  get '/*path' =>  'homepage#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
