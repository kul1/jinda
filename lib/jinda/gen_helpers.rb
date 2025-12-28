########################################################################
#                  Methods to be overrided by gemhelp                  #
#                            for Rspec Test
########################################################################
def gen_view_file_exist?(dir)
  File.exist?(dir)
end

def gen_view_mkdir(dir, t)
  FileUtils.mkdir_p(dir) unless File.exist?(dir)
  t << "create directory #{dir}"
end

def gen_view_createfile(s, f, t)
  FileUtils.cp s, f
  # FileUtils.cp "app/jinda/template/linkview.haml",f
  t << "create file #{f}"
end
########################################################################

def controller_exists?(modul)
  File.exist? "#{Rails.root.join("app/controllers/#{modul}_controller.rb")}"
end

def dup_hash(a)
  h = Hash.new(0)
  a.each do |aa|
    h[aa] += 1
  end
  h
end

def login?
  ## To use remember me cookies then remove
  # session[:user_id] != nil
  current_ma_user != nil
  # cookies[:auth_token] != nil
end

def own_xmain?
  if $xmain
    current_ma_user.id == $xvars['user_id']
  else
    # if eval on first step would return true so user can start service
    true
  end
end

# return nil or value of opt: if provided
def get_option_xml(opt, xml)
  return unless xml

  url = ''
  xml.each_element('node') do |n|
    text = n.attributes['TEXT']
    # check if opt match from beginning of text
    url = text if /^#{opt}/.match?(text)
  end
  return nil if url.blank?

  _, h = url.split(':', 2)
  opt = h ? h.strip : true
end

def m_icon(node)
  mcons = []
  node.each_element('icon') do |mn|
    mcons << mn.attributes['BUILTIN']
  end
  mcons[0].to_s
end

# Option to unlisted in the menu_mm if icon 'button_cancel'
def listed(node)
  icons = []
  node.each_element('icon') do |nn|
    icons << nn.attributes['BUILTIN']
  end

  !icons.include?('button_cancel')
end

def ma_secured?(node)
  icons = []
  node.each_element('icon') do |nn|
    icons << nn.attributes['BUILTIN']
  end
  icons.include?('password')
end

def ma_menu?
  icons = []
  node.each_element('icon') do |mn|
    icons << mn.attributes['BUILTIN']
  end
  icons.include?('menu')
end

def freemind2action(s)
  case s.downcase
    # when 'bookmark' # Excellent
    #  'call'
  when 'bookmark' # Excellent
    'do'
  when 'attach' # Look here
    'form'
  when 'edit' # Refine
    'pdf'
  when 'wizard' # Magic
    'ws'
  when 'help' # Question
    'if'
  when 'forward' # Forward
    # 'redirect'
    'direct_to'
  when 'kaddressbook' # Phone
    'invoke' # invoke new service along the way
  when 'idea' # output
    'output'
  when 'list' # List
    'list'
  when 'folder' # Folder
    'folder'
  when 'mail'
    'mail'
  # when 'xmag' # Tobe discussed
  when 'To be discusssed'
    'search'
  end
end

def affirm(s)
  /[y|estru]/i.match?(s) || false
end

def negate(s)
  /[n|ofalse]/i.match?(s) || false
end

# module FormBuilder
#   def date_field(method, options = {})
#     default= self.object.send(method) || Date.today
#     data_options= ({"mode"=>"calbox"}).merge(options)
#     %Q(<input name='#{self.object_name}[#{method}]' id='#{self.object_name}_#{method}' value='#{default.strftime("%F")}' type='date' data-role='datebox' data-options='#{data_options.to_json}'>).html_safe
#   end
# end
