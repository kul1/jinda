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
	# Test if create only new controller from mm.
	# By removed ctrs_controller.rb from template
	# Then test if only try to created output from gemhelpers
	it 'process_controllers only new controller' do
		expect(STDOUT).to receive(:puts).with('    Rails generate controller ctrs')
		result = process_controllers
	end

	it 'generate view files' do
    result = gen_views
		result.each do |r|
			#expected_file = $gem_root + "/spec/temp/" + r
			expected_file = "spec/temp/" + r
			fexist = File.exist?(expected_file)
			expect(fexist).to be true
		end
	end

end
