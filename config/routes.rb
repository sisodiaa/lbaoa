Rails.application.routes.draw do
  namespace :cms do
    resources :departments, except: :destroy
    resources :posts do
      resources :documents, only: %i[index create destroy]
      put 'publish', on: :member
      patch 'publish', on: :member
    end

    devise_for :admins, skip: %i[registrations], controllers: {
      sessions: 'cms/admins/sessions',
      passwords: 'cms/admins/passwords',
      confirmations: 'cms/admins/confirmations',
      unlocks: 'cms/admins/unlocks'
    }

    devise_scope :cms_admin do
      authenticated :cms_admin do
        root to: 'posts#index', as: :admin_root
      end

      unauthenticated do
        root to: 'admins/sessions#new'
      end
    end
  end

  devise_scope :cms_admin do
    get '/cms/admins/edit',
        to: 'cms/admins/registrations#edit',
        as: 'edit_cms_admin_registration'

    match '/cms/admins',
          to: 'cms/admins/registrations#update',
          as: 'cms_admin_registration',
          via: %i[put patch]
  end

  resources :posts, only: %i[index show]

  root to: 'posts#index'
end
