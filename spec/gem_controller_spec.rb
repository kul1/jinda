# frozen_string_literal: true

require_relative 'spec_helper'

# include Jinda::GemHelpers

describe Jinda::GemHelpers do
  before(:all) do
    MM = 'lib/generators/jinda/templates/app/jinda/index.mm'
    @app = get_app
    # Find gem root
    spec = Gem::Specification.find_by_name('jinda')
    $gem_root = spec.gem_dir
  end
  it 'index.mm is ready in templates/app/jinda ' do
    result = REXML::Document.new(File.read(MM).gsub('\n', '')).root
    expect(result).not_to be_nil
  end

  it 'process_services features ' do
    result = process_services
    expect(result).not_to be_nil
  end

  # To test if can create only new controller from mm.
  # By check method controller_exists?(modul) in lib..template

  it 'process_controllers check if any controller exists' do
    check_module = 'users'
    result = File.exist? $gem_root + "/lib/generators/jinda/templates/app/controllers/jinda_org/#{check_module}_controller.rb"
    expect(result).to be true
  end

  it 'process_controllers check if any controller non exists' do
    check_module = 'non-exist'
    result = File.exist? $gem_root + "/lib/generators/jinda/templates/app/controllers/jinda_org/#{check_module}_controller.rb"
    expect(result).to be false
  end

  it 'generate new view files from mm file' do
    result = gen_views('spec/temp')
    $gem_dir = Dir.getwd
    result.each do |r|
      expected_file = "#{$gem_dir}/#{r}"
      fexist = File.exist?(expected_file)
      expect(fexist).to be true
    end
  end

  after(:all) do
    `rm -rf spec/temp`
    puts '*** temp files removed  ***'
  end
end
