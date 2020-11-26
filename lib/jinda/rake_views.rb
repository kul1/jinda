    ########################################################################
    #                            Jinda Rake Task                           #
    ########################################################################

    def gen_views
      t = ["*** generate ui ***"]

      # create array of files to be tested
      $afile = Array.new

      Jinda::Module.all.each do |m|
        m.services.each do |s|
          dir ="app/views/#{s.module.code}"
          unless gen_view_file_exist?(dir)
            gen_view_mkdir(dir,t) 
          end

          if s.code=='link'
            f= "app/views/#{s.module.code}/index.haml"
            $afile << f
            unless gen_view_file_exist?(f)
              sv = "app/jinda/template/linkview.haml"
              f= "app/views/#{s.module.code}/index.haml"
              gen_view_createfile(sv,f,t)
            end
            next   
          end

          dir ="app/views/#{s.module.code}/#{s.code}"
          unless gen_view_file_exist?(dir)
            gen_view_mkdir(dir,t) 
          end

          xml= REXML::Document.new(s.xml)
          xml.elements.each('*/node') do |activity|
            icon = activity.elements['icon']
            next unless icon
            action= freemind2action(icon.attributes['BUILTIN'])
            next unless ui_action?(action)
            code_name = activity.attributes["TEXT"].to_s
            next if code_name.comment?
            code= name2code(code_name)
            if action=="pdf"
              f= "app/views/#{s.module.code}/#{s.code}/#{code}.pdf.prawn"
            else
              f= "app/views/#{s.module.code}/#{s.code}/#{code}.html.erb"
            end
            $afile << f
            unless gen_view_file_exist?(f)
              sv = "app/jinda/template/view.html.erb"
              gen_view_createfile(sv,f,t)
            end
          end
        end
      end
      puts $afile.join("\n")
      puts t.join("\n")
      return $afile  
    end
