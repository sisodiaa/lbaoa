Rails.application.routes.draw do
  namespace :cms do
    resources :departments, except: :destroy
    resources :posts do
      resources :documents, only: %i[index create destroy]
      put 'publish', on: :member
      patch 'publish', on: :member
    end
  end

  resources :posts, only: %i[index show]

  root to: 'posts#index'
end
