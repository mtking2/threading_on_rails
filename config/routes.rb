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
	post 'reports/purge_past_reports', to: 'reports#purge_past_reports'

	get 'dining_philosophers/', to: 'dining_philosophers#index'
	post 'dining_philosophers/start', to: 'dining_philosophers#start'
	post 'dining_philosophers/pause', to: 'dining_philosophers#pause'
	post 'dining_philosophers/stop', to: 'dining_philosophers#stop'
end
