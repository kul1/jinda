require 'jinda/helpers'
require 'active_support/core_ext/regexp'
require 'mongoid'
require_relative '../lib/generators/jinda/templates/app/models/jinda/module.rb'
require_relative '../lib/generators/jinda/templates/app/models/jinda/service.rb'
#Dir[File.dirname(__FILE__) + './lib/generators/jinda/templates/app/models/jinda'].each {|file| puts file}
require 'dotenv'
Dotenv.load
Mongoid.load!('./mongoid.yml')
include Jinda::Helpers
describe Jinda::Helpers do
  before(:each) do
    MM = 'lib/generators/jinda/templates/app/jinda/index.mm'
		@app = get_app
  end
  it 'index.mm is ready in templates/app/jinda ' do
    result = REXML::Document. new(File.read(MM).gsub('\n', '')).root
    expect(result).not_to be_nil
  end

	it 'process_services' do
		result = process_services
		expect(result).not_to be_nil
	end
end
