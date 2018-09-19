Rails.application.routes.draw do
  resources :news
  resources :requests
  resources :communities
  resources :users
  resources :community_members
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace 'api' do
    post 'users/login', to: 'users#login'
    post 'users/register', to: 'users#register'
    put 'users/edit', to: 'users#edit'
    put 'users/update_image', to: 'users#update_image'
    post 'communities/create', to: 'communities#create'
    get 'communities/get_communities', to: 'communities#get_communities'
    get 'communities/search_community', to: 'communities#search_community'
    get 'communities/get_members', to: 'communities#get_members'
    get 'requests/get', to: 'requests#get'
    post 'requests/create', to: 'requests#create'
    post 'requests/accept', to: 'requests#accept'
    #put 'requests/put_seens', to: 'requests#put_seens'
    delete 'requests/delete', to: 'requests#delete'
    get 'requests/count_new_requests', to: 'requests#count_new_requests'
    post 'news/create', to: 'news#create'
    get 'news/get_news', to: 'news#get_news'
    get 'news/get_news_status', to: 'news#get_news_status'
    put 'news/approve_news', to: 'news#approve_news'
    delete 'news/delete_news', to: 'news#delete_news'

  end
end
