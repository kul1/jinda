    # ##########################################################################
    #                         Update module from Rails
    # ##########################################################################
    def gen_module_controller
      # find s_controller name in Jinda::Module
      # if found ..
      # else 
      #   create
      # end
      #
      # MM was defined in Rails: config/initializer/jinda.rb
      @prefix = "spec/temp/"
      @tdir   = "#{@prefix}app/controllers/*_controller.rb"
      # dir_module_names = Dir.glob("#{@prefix}app/controllers/*_controller.rb").map { |path| (path.match(/(\w+)/); $1) }
      dir_module_names = Dir.glob(@tdir).map {|path| (path.match(/(\w+)_controller.rb/); $1)}
      binding.pry
    end
