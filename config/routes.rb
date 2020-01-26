require 'sidekiq/web'

Rails.application.routes.draw do
  # TODO: basic auth
  mount Sidekiq::Web => '/sidekiq'
end
