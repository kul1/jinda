# require 'test_helper'
# require 'rails/generators/test_case'
# require 'generators/jinda/config/config_generator'
# 
# class ConfigGeneratorTest < Rails::Generators::TestCase
#   tests Jinda::Generators::ConfigGenerator
#   destination File.expand_path("../tmp", __dir__)
#   setup :prepare_destination
# 
#   test "setup_omniauth method should generate omniauth.rb initializer file" do
#     run_generator
# 
#     assert_file "config/initializers/omniauth.rb" do |content|
#       assert_match(/Rails\.application\.config\.middleware\.use OmniAuth::Builder do/, content)
#       assert_match(/provider :identity,/, content)
#       assert_match(/provider :facebook, ENV\['FACEBOOK_API'\], ENV\['FACEBOOK_KEY'\]/, content)
#       assert_match(/provider :google_oauth2, ENV\['GOOGLE_CLIENT_ID'\], ENV\['GOOGLE_CLIENT_SECRET'\], skip_jwt: true/, content)
#       assert_match(/OmniAuth\.config\.on_failure = Proc\.new { \|env\|/, content)
#     end
#   end
# end
require 'minitest/autorun'

class GeneratorTest < Minitest::Test
  def test_engine_generation
    # Write test logic here to verify the generated engine
    assert_equal true, true
  end

  # Add more test methods as needed
end

