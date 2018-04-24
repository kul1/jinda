require 'spec_helper.rb'
require 'jinda/gemhelpers'
include Jinda::GemHelpers

describe Jinda::GemHelpers do
  before(:all) do
    MM = 'lib/generators/jinda/templates/app/jinda/index.mm'
		@app = get_app
  end
  it 'index.mm is ready in templates/app/jinda ' do
    result = REXML::Document. new(File.read(MM).gsub('\n', '')).root
    expect(result).not_to be_nil
  end

	it 'process_services features ' do
		result = process_services
		expect(result).not_to be_nil
	end

	it 'process_controllers features if no controller' do
		result = process_controllers
		expect(result).not_to be_nil
	end

	it 'generate view' do
    result = gen_views
		expect(result).not_to be_nil
	end
end
