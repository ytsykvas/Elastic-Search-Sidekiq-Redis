# frozen_string_literal: true

Rails.application.routes.draw do
  require 'sidekiq/web'

  root 'dashboard#index'
  get 'up' => 'rails/health#show', as: :rails_health_check

  resources :weather, only: [:index]
  resources :customers, only: [:index, :statistic] do
    collection do
      get 'statistic'
    end
  end
  resources :tasks, except: [:edit] do
    member do
      post 'mark_done'
    end
  end

  if Rails.env.development?
    Rails.application.routes.draw do
      mount Sidekiq::Web => '/sidekiq'
    end
  end
end
