Rails.application.config.middleware.use OmniAuth::Builder do
  provider :identity,
           :fields                 => %i[code email],
           :on_failed_registration => lambda { |env|
             IdentitiesController.action(:new).call(env)
           }
  provider :facebook, ENV.fetch("FACEBOOK_API", nil), ENV.fetch("FACEBOOK_KEY", nil)
  provider :google_oauth2, ENV.fetch("GOOGLE_CLIENT_ID", nil), ENV.fetch("GOOGLE_CLIENT_SECRET", nil), skip_jwt: true
end

# https://stackoverflow.com/questions/11461084/handle-omniautherror-invalid-credentials-for-identity-login
OmniAuth.config.on_failure = proc do |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
end
