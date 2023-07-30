# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# Set the default host and port to be the same as Action Mailer.
# Rails.application.default_url_options = Rails.application.config.action_mailer.default_url_options
Rails.application.routes.default_url_options = Rails.application.config.action_mailer.default_url_options

