# This GemHelpers is to make helper able to be test in gem (not in rails)
module Jinda	
  module GemHelpers
	  require 'jinda/helpers'
		include Jinda::Helpers
			# Find gem root 
			spec = Gem::Specification.find_by_name("jinda")
			@gem_root = spec.gem_dir

			def controller_exists?(modul)
			  spec = Gem::Specification.find_by_name("jinda")
			  gem_root = spec.gem_dir
				File.exists? gem_root + "/lib/generators/jinda/templates/app/controllers/#{modul}_controller.rb"
			end

			#
			# Mock generate controller for test
			# Otherwise test will call rails g controller
			#
			def process_controllers
				process_services
				modules= Jinda::Module.all
				modules.each do |m|
					next if controller_exists?(m.code)
					puts "    Rails generate controller #{m.code}"
				end
			end

			def gen_views
				t = ["*** generate ui ***"]
			end
	end
end
	
