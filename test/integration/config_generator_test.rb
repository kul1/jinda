require 'test_helper'
require 'generators/jinda/config/config_generator'
require 'pry'

class ConfigGeneratorTest < Rails::Generators::TestCase
  tests Jinda::Generators::ConfigGenerator
  destination File.expand_path('../../tmp', __FILE__)
  setup :prepare_destination

  test "backup_files method moves .env file to .env-bak if it exists" do
    FileUtils.touch("#{destination_root}/.env")
    assert File.exist?("#{destination_root}/.env")

    run_generator
    refute File.exist?("#{destination_root}/.env")
    assert File.exist?("#{destination_root}/.env-bak")
  end

  test "gen_image_store method creates an 'upload' directory" do
    run_generator
    assert File.directory?("#{destination_root}/upload")
  end

  # Add more tests for other methods as needed...

end

