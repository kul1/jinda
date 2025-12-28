# ##########################################################################
#                         Load index.mm from Rails
# ##########################################################################
def get_app
  # MM was defined in Rails: config/initializer/jinda.rb
  f = MM || "#{Rails.root.join('app/jinda/index.mm')}"
  dir = File.dirname(f)
  t = REXML::Document.new(File.read(MM).delete("\n")).root
  recheck = true
  first_pass = true
  while recheck
    recheck = false
    t.elements.each('//node') do |n|
      next unless n.attributes['LINK'] # has attached file

      f = if first_pass
            "#{dir}/#{n.attributes['LINK']}"
          else
            n.attributes['LINK']
          end
      next unless File.exist?(f)

      tt = REXML::Document.new(File.read(f).delete("\n")).root.elements['node']
      make_folders_absolute(f, tt)
      tt.elements.each('node') do |tt_node|
        n.parent.insert_before n, tt_node
      end
      recheck = true
      n.parent.delete_element n
    end
    first_pass = false
  end
  t
end
