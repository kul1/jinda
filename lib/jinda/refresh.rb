def b(s)
  "<b>#{s}</b>".html_safe
end

def link_to_blank(body, url_options = {}, html_options = {})
  link_to(body, url_options, html_options.merge(target: '_blank'))
end

def code_text(s) # old def code(s)
  "<pre style='background-color: #efffef;'><code class='ruby' lang='ruby'>#{s}</code></pre>".html_safe
end

def refresh_to(url = '/', option = {})
  ma_log option[:alert] if option[:alert]
  # skip #
  # Rails 5.2 not allow to use js inline call
  render inline: "<script>window.location.replace('#{url}')</script>"
  # redirect_to url
  # render js: "window.location.replace(\'#{url}\')"
end

# def refresh_to
#   respond_to do |format|
#     format.js { render :js => "refresh();" }
#   end
# end

def read_binary(path)
  File.binread(path)
end

def redirect_to_root
  redirect_to root_path
end

# Todo refactor code
def get_option(opt, runseq = @runseq)
  xml = REXML::Document.new(runseq.xml).root
  url = ''
  # get option from second element of node using '//node'
  xml.each_element('//node') do |n|
    if n.attributes['TEXT']
      text = n.attributes['TEXT']
      url = text if /^#{opt}:\s*/.match?(text)
    end
  end
  return nil if url.blank?

  _, h = url.split(':', 2)
  opt = h ? h.strip : false
end

def ma_comment?(s)
  s[0] == 35
end

def get_ip
  request.env['HTTP_X_FORWARDED_FOR'] || request.env['REMOTE_ADDR']
end

def get_default_role
  default_role = Jinda::Role.where(code: 'default').first
  default_role ? default_role.name.to_s : ''
end

def sign_in?
  return true if current_ma_user.present?

  false
end
