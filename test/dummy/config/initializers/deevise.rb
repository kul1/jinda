
# config/initializers/devise.rb
                    Devise.setup do |config|
                      config.omniauth :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
                    end
                  
