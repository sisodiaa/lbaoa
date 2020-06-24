Rails.application.routes.draw do
  namespace :cms do
    resources :departments, except: :destroy
    resources :posts
  end
end
