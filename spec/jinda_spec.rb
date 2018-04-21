require 'jinda/helpers'
include Jinda::Helpers
describe Jinda::Helpers do
  it 'index.mm is ready in templates/app/jinda ' do
    MM = 'lib/generators/jinda/templates/app/jinda/index.mm'
    result = REXML::Document. new(File.read(MM).gsub('\n', '')).root
    expect(result).not_to be_nil
  end
end
