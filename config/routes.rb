Rails.application.routes.draw do
  resources :posts do
    resources :comments, only: [:create, :destroy]
  end
  resources :categories, only: [:index, :show]
  root 'posts#index'
end
