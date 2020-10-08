Rails.application.routes.draw do
  require 'sidekiq/web'
  if Rails.env.production?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      username == '<%= Rails.application.credentials.dig(:production, :sidekiq, :username) %>' &&
        password == '<%= Rails.application.credentials.dig(:production, :sidekiq, :password) %>'
    end
  end
  mount Sidekiq::Web => '/sidekiq'

  namespace :management do
    get 'dashboard', to: 'dashboard#index', as: 'dashboard'
  end

  namespace :cms do
    resources :categories, except: :destroy

    resources :posts, except: :index do
      put 'publish', on: :member
      patch 'publish', on: :member

      put 'cast', on: :member
      patch 'cast', on: :member

      get 'drafts', to: 'posts#index', status: 'draft', on: :collection
      get '/', to: 'posts#index', status: 'draft', on: :collection
      get 'published', to: 'posts#index', status: 'published', on: :collection
    end
  end

  resources :posts, only: [], path: '/cms/posts' do
    resources :documents, only: %i[index create destroy]
  end

  namespace :tms do
    resources :notices, param: :reference_token do
      put 'publish', on: :member
      patch 'publish', on: :member

      %w[draft upcoming current under_review archived].each do |status|
        get status, to: 'notices#index', status: status, on: :collection
      end
      get '/', to: 'notices#index', status: 'current', on: :collection
    end

    post '/notices/:reference_token/proposals/selection',
         to: 'proposal_selection#create',
         as: 'proposal_selection'
  end

  resources :tender_notices, only: [], path: '/tms/notices', param: :reference_token do
    resource :document, only: %i[show create destroy]
  end

  devise_for :admins, skip: %i[registrations], controllers: {
    sessions: 'account/admins/sessions',
    passwords: 'account/admins/passwords',
    confirmations: 'account/admins/confirmations',
    unlocks: 'account/admins/unlocks'
  }

  devise_for :members, skip: %i[registrations], controllers: {
    sessions: 'account/members/sessions',
    passwords: 'account/members/passwords',
    confirmations: 'account/members/confirmations',
    unlocks: 'account/members/unlocks'
  }

  scope module: 'account' do
    devise_scope :admin do
      get '/admins/edit',
          to: 'admins/registrations#edit',
          as: 'edit_admin_registration'

      match '/admins',
            to: 'admins/registrations#update',
            as: 'admin_registration',
            via: %i[put patch]

      scope '/management' do
        unauthenticated do
          root to: 'admins/sessions#new', as: :management_root
        end
      end
    end

    devise_scope :member do
      resource :registration,
               only: %i[new create edit update],
               path: 'members',
               path_names: { new: 'sign_up' },
               controller: 'members/registrations',
               as: :member_registration
    end

    resources(
      :members,
      controller: 'members/dashboard',
      except: %i[new create destroy]
    ) do
      %w[pending approved flagged archived bogus].each do |status|
        get status, to: 'members/dashboard#index', status: status, on: :collection
      end
    end
  end

  devise_scope :admin do
    authenticated :admin do
      root to: 'management/dashboard#index', as: :admin_root
    end
  end

  devise_scope :member do
    authenticated :member do
      root to: 'posts#index', as: :member_root
    end
  end

  resources :posts, only: %i[index show]

  namespace :tender do
    resources :notices, only: %i[index show], param: :reference_token do
      %w[upcoming current under_review archived].each do |status|
        get status, to: 'notices#index', status: status, on: :collection
      end
      get '/', to: 'notices#index', status: 'current', on: :collection
      resources :proposals,
                shallow: true,
                param: :token,
                except: %w[edit update destroy]
    end
  end

  namespace :search do
    get 'posts', to: 'posts#index', as: 'posts'
    get 'members', to: 'members#index', as: 'members'
  end

  get '/pages/*page', to: 'cms/pages#show', as: 'page'

  get 'public_document',
      to: 'cms/pages#send_public_document',
      as: 'public_document'

  root to: 'cms/pages#show', page: 'home'
end
