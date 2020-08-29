require 'sidekiq/web'

Rails.application.routes.draw do
  get 'dashboard/index'
  root to: 'dashboard#index'
  get '/broadcast', to: 'dashboard#broadcast', as: :broadcast
  get '/button', to: 'dashboard#set_button', as: :button
  mount ActionCable.server,  at: '/cable'
  mount Sidekiq::Web => '/sidekiq'
end
