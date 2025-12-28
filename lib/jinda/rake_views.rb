########################################################################
#                            Jinda Rake Task                           #
########################################################################

def gen_views(prefix = '')
  @prefix = prefix.empty? ? '' : (prefix + '/')
  t = ['*** generate ui ***']

  # create array of files to be tested
  $afile = []

  Jinda::Module.all.each do |m|
    m.services.each do |s|
      dir = @prefix + "app/views/#{s.module.code}"
      gen_view_mkdir(dir, t) unless gen_view_file_exist?(dir)

      if s.code == 'link'
        f = @prefix + "app/views/#{s.module.code}/index.haml"
        $afile << f
        unless gen_view_file_exist?(f)
          # check if test (@prefix)
          # sv = "app/jinda/template/linkview.haml"
          sv = @prefix.blank? ? 'app/jinda/template/linkview.haml' : 'lib/generators/jinda/templates/app/jinda/template/linkview.haml'
          f = @prefix + "app/views/#{s.module.code}/index.haml"
          gen_view_createfile(sv, f, t)
        end
        next
      end

      dir = @prefix + "app/views/#{s.module.code}/#{s.code}"
      gen_view_mkdir(dir, t) unless gen_view_file_exist?(dir)

      xml = REXML::Document.new(s.xml)
      xml.elements.each('*/node') do |activity|
        icon = activity.elements['icon']
        next unless icon

        action = freemind2action(icon.attributes['BUILTIN'])
        next unless ui_action?(action)

        code_name = activity.attributes['TEXT'].to_s
        next if code_name.comment?

        code = name2code(code_name)
        f = if action == 'pdf'
              @prefix + "app/views/#{s.module.code}/#{s.code}/#{code}.pdf.prawn"
            else
              @prefix + "app/views/#{s.module.code}/#{s.code}/#{code}.html.erb"
            end
        $afile << f
        next if gen_view_file_exist?(f)

        # sv = "app/jinda/template/view.html.erb"
        sv = @prefix.blank? ? 'app/jinda/template/linkview.haml' : 'lib/generators/jinda/templates/app/jinda/template/linkview.haml'
        gen_view_createfile(sv, f, t)
      end
    end
  end
  puts $afile.join("\n")
  puts t.join("\n")
  $afile
end
