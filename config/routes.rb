Rails.application.routes.draw do
  scope '/cms' do
    resources :departments
  end
end
