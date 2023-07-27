require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ThreadingDemo
	class Application < Rails::Application
		# Initialize configuration defaults for originally generated Rails version.
		config.load_defaults 5.2

		# Settings in config/environments/* take precedence over those specified here.
		# Application configuration can go into files in config/initializers
		# -- all .rb files in that directory are automatically loaded after loading
		# the framework and any gems in your application.

		# Custom directories with classes and modules you want to be autoloadable.
		config.autoload_paths += %W(lib app/classes app/concerns).map{|m| config.root.join(m).to_s }

		config.active_job.queue_adapter = :sidekiq
	end
end
