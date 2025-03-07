# Fix for Logger constant access in ActiveSupport::LoggerThreadSafeLevel
require 'logger'

# Ensure Logger is properly accessible within ActiveSupport
module ActiveSupport
  module LoggerThreadSafeLevel
    unless const_defined?(:Logger)
      # Define Logger within the module to point to the global Logger class
      const_set(:Logger, ::Logger)
    end
  end
end
