require 'sidekiq/web'

Rails.application.routes.draw do
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	mount ActionCable.server => '/cable'
	mount Sidekiq::Web => '/sidekiq'

	root to: 'dashboard#index'

	get 'pc/', to: 'pc#index'
	post 'pc/add_producer', to: 'pc#add_producer'
	post 'pc/add_consumer', to: 'pc#add_consumer'
	post 'pc/start', to: 'pc#start'
	post 'pc/pause', to: 'pc#pause'
	post 'pc/stop', to: 'pc#stop'
	post 'pc/kill_thread', to: 'pc#kill_thread'

	get 'reports/', to: 'reports#index'
	post 'reports/csv_report', to: 'reports#csv_report'
end
