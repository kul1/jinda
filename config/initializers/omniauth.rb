
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :identity,
           :fields => [:code, :email],
           :on_failed_registration=> lambda { |env|
             IdentitiesController.action(:new).call(env)
           }
  provider :facebook, ENV['FACEBOOK_API'], ENV['FACEBOOK_KEY']
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], skip_jwt: true
end

# https://stackoverflow.com/questions/11461084/handle-omniautherror-invalid-credentials-for-identity-login
OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

                  
