require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Board
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Rails 5.0 framework defaults. Rails 5.0 has no `config.load_defaults`, and
    # these must be set here rather than in config/initializers: gems load
    # ActiveRecord::Base / ActionController::Base before initializers run, so
    # values set there are never applied. Replace with `config.load_defaults`
    # when upgrading to Rails 5.1.
    config.action_controller.raise_on_unfiltered_parameters = true
    config.action_controller.per_form_csrf_tokens = true
    config.action_controller.forgery_protection_origin_check = true
    config.active_record.belongs_to_required_by_default = true
    ActiveSupport.to_time_preserves_timezone = true
    ActiveSupport.halt_callback_chains_on_return_false = false
  end
end
