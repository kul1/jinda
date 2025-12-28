# frozen_string_literal: true

# ############################### Themes ###################################
#
# Check login user information from User model: name(code), image for Themes
#
# ##########################################################################
def get_login_user_info
  if current_ma_user.present?
    $user_image = (current_ma_user.image == '' ? asset_url('user.png', width: '48') : current_ma_user.image)
    $user_name = current_ma_user.code
    $user_email = current_ma_user.email
    $user_id = current_ma_user.try(:id)
  else
    $user_image = asset_url('user.png', width: '48')
    $user_name = 'Guest User'
    $user_email = 'guest@sample.com'
    $user_id = ''
  end
  [$user_image, $user_name, $user_email, $user_id]
end

# search image from User in Article/View/Show
def get_user_image(user_id)
  user_image = User.find(user_id).image
  (user_image == '' ? asset_url('user.png', width: '48') : user_image)
end

def name2code(s)
  # rather not ignore # symbol cause it could be comment
  code, = s.split(':')
  code.downcase.strip.tr(' ', '_').gsub(%r{[^#_/a-zA-Z0-9]}, '')
end

def name2camel(s)
  s.tr(' ', '_').camelcase
end

def true_action?(s)
  %w[call ws redirect invoke email].include? s
end

def set_global
  $xmain = @xmain
  $runseq = @runseq
  $user = current_ma_user
  $xvars = @xmain.xvars
  $ip = request.env['REMOTE_ADDR']
end

# use in pending tasks
def authorize?
  @runseq = @xmain.runseqs.find @xmain.current_runseq
  return false unless @runseq

  @user = current_ma_user
  set_global
  return false if @runseq.rule && @runseq.rule && !eval(@runseq.rule)
  return true if true_action?(@runseq.action)
  # return false if check_wait
  return true if @runseq.role.blank?

  unless @runseq.role.empty?
    return false unless @user.role

    return @user.role.upcase.split(',').include?(@runseq.role.upcase)
  end
  true
end

# use when initialize new transaction
def authorize_init?
  # check module role
  mrole = @service.module.role
  return false if mrole && !current_ma_user
  return false if mrole && !current_ma_user.has_role(mrole)

  # check step 1 role
  xml = @service.xml
  step1 = REXML::Document.new(xml).root.elements['node']
  role = get_option_xml('role', step1) || ''
  #    rule= get_option_xml("rule", step1) || true
  get_option_xml('rule', step1) || true
  return true if role == ''
  return role.blank? unless current_ma_user

  return false unless current_ma_user.role

  current_ma_user.has_role(role)
end

def ma_log(message)
  #  Jinda::Notice.create :message => ERB::Util.html_escape(message.gsub("`","'")),
  #    :unread=> true, :ip=> ($ip || request.env["REMOTE_ADDR"])
  if session[:user_id]
    Jinda::Notice.create message: ERB::Util.html_escape(message.tr('`', "'")),
                         user_id: $user.id, unread: true, ip: request.env['REMOTE_ADDR']
  else
    Jinda::Notice.create message: ERB::Util.html_escape(message.tr('`', "'")),
                         unread: true, ip: request.env['REMOTE_ADDR']
  end
end

alias ma_notice ma_log

# methods from application_helper
def markdown(text)
  begin
    erbified = ERB.new(text.html_safe).result(binding)
  rescue StandardError => e
    flash[:notice] = "This ruby version not support #{e}"
    return
  end
  red = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, space_after_headers: true)
  red.render(erbified).html_safe
end

def align_text(s, pixel = 3)
  "<span style='position:relative; top:-#{pixel}px;'>#{s}</span>".html_safe
end

def status_icon(status)
  case status
  when 'R'
    image_tag 'user.png'
  when 'F'
    image_tag 'tick.png'
  when 'I'
    image_tag 'control_play.png'
  when 'E'
    image_tag 'logout.png'
  when 'X'
    image_tag 'cross.png'
  else
    image_tag 'cancel.png'
  end
end

def role_name(code)
  role = Jinda::Role.where(code: code).first
  role ? role.name : ''
end

def uncomment(s)
  s.sub(/^#\s/, '')
end

def code_div(s)
  "<pre style='background-color: #efffef;'><code class='ruby' lang='ruby'>    #{s}</code></pre>".html_safe
end

def ajax?(s)
  !s.match?('file_field')
end

# square text
def step(s, total)
  s = s.zero? ? 1 : s.to_i
  total = total.to_i
  out = "<div class='step'>"
  (s - 1).times { |ss| out += "<span class='steps_done'>#{ss + 1}</span>" }
  out += %(<span class='step_now' >)
  out += s.to_s
  out += '</span>'
  out += %()
  ((s + 1)..total).each do |i|
    out += "<span class='steps_more'>#{i}</span>"
  end
  out += '</div>'
  out.html_safe
end

def current_ma_user
  # if session[:user_id]
  #   return @user ||= User.find(session[:user_id]['$oid'])
  # else
  #   return nil
  # end
  # @user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  @user ||= User.where(auth_token: cookies[:auth_token]).first if cookies[:auth_token]
  @user
end

def ui_action?(s)
  %w[form output mail pdf].include? s
end
# def handle_ma_notice
#   if Jinda::Notice.recent.count>0
#     notice= Jinda::Notice.recent.last
#     notice.update_attribute :unread, false
#     "<script>notice('#{notice.message}');</script>"
#   else
#     ""
#   end
# end
