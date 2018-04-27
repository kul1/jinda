# This GemHelpers is to make helper able to be test in gem (not in rails)
module Jinda	
  module GemHelpers
	  require 'jinda/helpers'
		include Jinda::Helpers

			# Find gem root 
			spec = Gem::Specification.find_by_name("jinda")
			$gem_root = spec.gem_dir

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
				t = ["*** generate ui #{$gem_root} ***"]
				#puts $gem_root
			end
		def gen_view_file_exist?(dir)
			vdir = $gem_root+dir
			puts vdir
			File.exists?(vdir)
		end
		def gen_view_mkdir(dir,t)
			vdir = $gem_root+dir
			Dir.mkdir(vdir)
			t << "create directory #{vdir}"
		end

		def gen_view_createfile(f,t)
			FileUtils.cp "#{$gem_root}/lib/generators/jinda/templates/app/jinda/template/linkview.haml",f
			t << "create file #{f}"
		end
		

	end
end
class String
	#
	# Put comment in freemind with #
	# Sample Freemind
	# #ctrs:ctrs&Menu
	#
	def comment?
		self[0]=='#'
	end
	def to_code
		s= self.dup
#    s.downcase!
#    s.gsub! /[\s\-_]/, ""
#    s
		code, name = s.split(':')
		code.downcase.strip.gsub(' ','_').gsub(/[^#_\/a-zA-Z0-9]/,'')
	end
end

