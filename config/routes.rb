require 'sidekiq/web'

Rails.application.routes.draw do
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	mount ActionCable.server => '/cable'
	mount Sidekiq::Web => '/sidekiq'

	root to: 'dashboard#index'

	post 'dashboard/add_producer', to: 'dashboard#add_producer'
	post 'dashboard/add_consumer', to: 'dashboard#add_consumer'
	post 'dashboard/start', to: 'dashboard#start'
	post 'dashboard/stop', to: 'dashboard#stop'
end
