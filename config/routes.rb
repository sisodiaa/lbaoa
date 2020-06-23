Rails.application.routes.draw do
  scope path: '/cms', as: 'cms' do
    resources :departments
    resources :posts
  end
end
