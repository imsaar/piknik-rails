# frozen_string_literal: true

# This patch fixes the "uninitialized constant ActiveSupport::LoggerThreadSafeLevel::Logger" error
# by ensuring the Logger constant is properly defined before it's used
require 'logger'

module LoggerThreadSafeLevelPatch
  def self.apply!
    # Ensure the directory exists
    FileUtils.mkdir_p(File.dirname(__FILE__)) unless Dir.exist?(File.dirname(__FILE__))
    
    # Define the proper constant reference for Logger
    module_eval <<-RUBY, __FILE__, __LINE__ + 1
      module ActiveSupport
        module LoggerThreadSafeLevel
          remove_const :Logger if defined?(Logger)
          Logger = ::Logger
        end
      end
    RUBY
  end
end
