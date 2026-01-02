# frozen_string_literal: true

# #######################################################################]
#  Each xmain  will create many run_seq as many as steps and form_steps
# #######################################################################]
#
##############################  @runseq ################################]
#  @runseq => #<Jinda::Runseq _id: 5df31912a54d758417a7afc9,
#   created_at: 2019-12-13 04:52:34 UTC,
#   updated_at: 2019-12-13 04:52:43 UTC,
#   user_id: nil,
#   xmain_id: BSON::ObjectId('5df31912a54d758417a7afc7'),
#   action: "do",
#   status: "R",
#   code: "create",
#   name: "Create Article",
#   role: "",
#   rule: "true",
#   rstep: 2,
#   form_step: 1,
#   start: 2019-12-13 04:52:43 UTC,
#   stop: nil,
#   end: true,
#   xml: "<node CREATED='1493419491125' ID='ID_1687683396' MODIFIED='1493483244848' TEXT='create: Create Article'><icon BUILTIN='bookmark'/></node>",
#   ip: nil>
# #######################################################################]

def create_runseq(xmain)
  @xvars                     = xmain.xvars
  default_role               = get_default_role
  xml                        = xmain.service.xml
  root                       = REXML::Document.new(xml).root
  i                          = 0
  j                          = 0 # i= step, j= form_step
  root.elements.each('node') do |activity|
    text = activity.attributes['TEXT']
    next if ma_comment?(text)
    next if /^rule:\s*/.match?(text)

    action = freemind2action(activity.elements['icon'].attributes['BUILTIN']) if activity.elements['icon']
    return false unless action

    i                   += 1
    output_ma_display    = false
    if action == ('output' || 'list' || 'folder')
      ma_display        = get_option_xml('display', activity)
      output_ma_display = if ma_display && !affirm(ma_display)
                            false
                          else
                            true
                          end
    end
    j                   += 1 if action == 'form' || output_ma_display
    @xvars['referer']    = activity.attributes['TEXT'] if action == 'redirect'
    if action != 'if' && text.present?
      scode, name = text.split(':', 2)
      name      ||= scode
      name.strip!
      code = name2code(scode)
    else
      code = text
      name = text
    end
    role                 = get_option_xml('role', activity) || default_role
    rule                 = get_option_xml('rule', activity) || 'true'
    runseq               = Jinda::Runseq.create xmain: xmain.id,
                                                name: name, action: action,
                                                code: code, role: role.upcase, rule: rule,
                                                rstep: i, form_step: j, status: 'I',
                                                xml: activity.to_s
    xmain.current_runseq = runseq.id if i == 1
  end
  @xvars['total_steps']      = i
  @xvars['total_form_steps'] = j
end
