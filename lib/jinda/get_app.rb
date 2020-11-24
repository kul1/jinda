

    # ##########################################################################
    #                         Load index.mm from Rails
    # ##########################################################################
    def get_app
      # MM was defined in Rails: config/initializer/jinda.rb
      f= MM || "#{Rails.root}/app/jinda/index.mm" 
      dir= File.dirname(f)
      t= REXML::Document.new(File.read(MM).gsub("\n","")).root
      recheck= true ; first_pass= true
      while recheck
        recheck= false
        t.elements.each("//node") do |n|
          if n.attributes['LINK'] # has attached file
            if first_pass
              f= "#{dir}/#{n.attributes['LINK']}"
            else
              f= n.attributes['LINK']
            end
            next unless File.exists?(f)
            tt= REXML::Document.new(File.read(f).gsub("\n","")).root.elements["node"]
            make_folders_absolute(f,tt)
            tt.elements.each("node") do |tt_node|
              n.parent.insert_before n, tt_node
            end
            recheck= true
            n.parent.delete_element n
          end
        end
        first_pass = false
      end
      return t
    end
