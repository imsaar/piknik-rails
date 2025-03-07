# Ensure Logger is loaded first and accessible in the global namespace
require "logger"

# Monkey patch for ActiveSupport::LoggerThreadSafeLevel
# This needs to be defined BEFORE loading Rails
module ActiveSupport
  module LoggerThreadSafeLevel
    # Define Logger constant within the module to point to the global Logger
    Logger = ::Logger
  end
end

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Piknik
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
