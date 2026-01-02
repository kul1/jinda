# frozen_string_literal: true

# ##########################################################################
#
# Create / Update Modules, Runseqs, Services from XML
#
# ##########################################################################
def process_services
  # TODO: persist mm_md5
  xml = @app || get_app
  if defined? session
    md5 = Digest::MD5.hexdigest(xml.to_s)
    if session[:mm_md5]
      return if session[:mm_md5] == md5
    else
      session[:mm_md5] = md5
    end
  end
  protected_services = []
  protected_modules  = []
  mseq               = 0
  @services          = xml.elements["//node[@TEXT='services']"] || REXML::Document.new
  @services.each_element('node') do |m|
    # get icon for service menu
    ss         = m.attributes['TEXT']
    code, name = ss.split(':', 2)
    next if code.blank?
    next if code.comment?

    module_code = code.to_code
    menu_icon   = m_icon(m)

    # ##########################################################################
    # First Node eg: Module Name
    # ##########################################################################
    # create or update to Jinda::Module model
    ma_module = Jinda::Module.find_or_create_by code: module_code
    ma_module.update uid: ma_module.id.to_s, icon: menu_icon
    protected_modules << ma_module.uid
    name = module_code if name.blank?
    ma_module.update name: name.strip, seq: mseq
    mseq     += 1
    seq       = 0

    # ##########################################################################
    # Second Nodes eg: Role, Link otherwise Services
    # ##########################################################################
    m.each_element('node') do |s|
      service_name = s.attributes['TEXT'].to_s
      scode, sname = service_name.split(':', 2)
      sname      ||= scode
      sname.strip!
      scode = scode.to_code
      if scode == 'role'
        ma_module.update_attribute :role, sname
        next
      end
      if scode.casecmp('link').zero?
        role       = get_option_xml('role', s) || ''
        rule       = get_option_xml('rule', s) || ''
        ma_service = Jinda::Service.find_or_create_by module_code: ma_module.code, code: scode, name: sname
      else

        # ##########################################################################
        # Second and Third Nodes eg: Role, Normal Services
        # ##########################################################################
        # normal service
        step1      = s.elements['node']
        role       = get_option_xml('role', step1) || ''
        rule       = get_option_xml('rule', step1) || ''
        ma_service = Jinda::Service.find_or_create_by module_code: ma_module.code, code: scode
      end
      ma_service.update xml: s.to_s, name: sname,
                        list: listed(s), ma_secured: ma_secured?(s),
                        module_id: ma_module.id, seq: seq,
                        confirm: get_option_xml('confirm', xml),
                        role: role, rule: rule, uid: ma_service.id.to_s
      seq += 1
      protected_services << ma_service.uid
    end
  end
  Jinda::Module.not_in(uid: protected_modules).delete_all
  Jinda::Service.not_in(uid: protected_services).delete_all
end
