Rails.application.routes.draw do
  namespace :cms do
    get 'dashboard', to: 'dashboard#index', as: 'dashboard'

    resources :categories, except: :destroy

    resources :posts, except: :index do
      resources :documents, only: %i[index create destroy]

      put 'publish', on: :member
      patch 'publish', on: :member

      put 'cast', on: :member
      patch 'cast', on: :member

      get 'drafts', to: 'posts#index', status: 'draft', on: :collection
      get '/', to: 'posts#index', status: 'draft', on: :collection
      get 'published', to: 'posts#index', status: 'published', on: :collection
    end

    devise_for :admins, skip: %i[registrations], controllers: {
      sessions: 'cms/admins/sessions',
      passwords: 'cms/admins/passwords',
      confirmations: 'cms/admins/confirmations',
      unlocks: 'cms/admins/unlocks'
    }

    devise_scope :cms_admin do
      authenticated :cms_admin do
        root to: 'dashboard#index', as: :admin_root
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

  devise_for :members, skip: %i[registrations], controllers: {
    sessions: 'members/sessions',
    passwords: 'members/passwords',
    confirmations: 'members/confirmations',
    unlocks: 'members/unlocks'
  }

  devise_scope :member do
    resource :registration,
             only: %i[new create edit update],
             path: 'members',
             path_names: { new: 'sign_up' },
             controller: 'members/registrations',
             as: :member_registration

    authenticated :member do
      root to: 'posts#index', as: :member_root
    end
  end

  resources :posts, only: %i[index show]

  namespace :search do
    get 'posts', to: 'posts#index', as: 'posts'
  end

  get '/pages/*page', to: 'cms/pages#show', as: 'page'

  get 'public_document',
      to: 'cms/pages#send_public_document',
      as: 'public_document'

  root to: 'cms/pages#show', page: 'home'
end
