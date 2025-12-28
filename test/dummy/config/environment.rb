# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# HACK: to fix cloudinary error https://github.com/archiloque/rest-client/issues/141
class Hash
  remove_method :read
rescue StandardError
end
