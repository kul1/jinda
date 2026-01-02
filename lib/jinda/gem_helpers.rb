# frozen_string_literal: true

# This GemHelpers is to make helper able to be test in gem (not in rails)
module Jinda
  module GemHelpers
    require 'jinda/helpers'
    include Jinda::Helpers

    # Find gem root
    spec      = Gem::Specification.find_by_name('jinda')
    $gem_root = spec.gem_dir
  end
end
