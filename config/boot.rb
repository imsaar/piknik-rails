ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.

# Fix for the Logger constant issue in ActiveSupport::LoggerThreadSafeLevel
require 'logger'

# Monkey patch to ensure Logger is globally accessible
module ActiveSupport
  module LoggerThreadSafeLevel
    # Explicitly set Logger to point to the global Logger class
    unless defined?(Logger)
      Logger = ::Logger
    end
  end
end
