# in spec/support/omniauth_macro.rb
module OmniauthMacros
require 'omniauth'
  #To enable all request to OmniAuth short circuited to use below mock authentication hash the  /auth/provider will redirect immediately to /auth/provider/call back
  # https://github.com/omniauth/omniauth/wiki/Integration-Testing
  OmniAuth.config.test_mode = true

  omniauth_hash = { 'provider' => 'google_oauth2',
                    'uid' => '105362273761620533373',
                    'info' => {
                        'name' => 'Kulsoft',
                        'email' => 'kulsoft.net@gmail.com',
                        'nickname' => 'kulsoft'
                    },
                    'extra' => {'raw_info' =>
                                    { 'location' => 'San Francisco',
                                      'gravatar_id' => '123456789'
                                    }
                    }
  }
  OmniAuth.config.add_mock(:google_oauth2, omniauth_hash)

  omniauth_hash = { 'provider' => 'facebook',
                    'uid' => '105362273761620533373',
                    'info' => {
                      'name' => 'Peter Colling',
                      'email' => '1.0@kul.asia',
                      'nickname' => 'Peter C'
                      },
                    'extra' => {'raw_info' =>
                      {'location' => 'LA',
                      'gravatar_id' => '13'
                      }
                    } 
                  } 
  OmniAuth.config.add_mock(:facebook, omniauth_hash)
end

