Rails.application.routes.draw do
  resources :users
  resources :community_members
  resources :communities
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
