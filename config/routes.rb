require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  get '/:queue_name/:id/:state', to: 'run_jobs#show'
end
