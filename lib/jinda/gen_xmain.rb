# frozen_string_literal: true

# #######################################################################]
# Each Service at one moment will create one xmain
# #######################################################################]
def create_xmain(service)
  c                 = name2camel(service.module.code)
  custom_controller = "#{c}Controller"
  params["return"]  = request.env["HTTP_REFERER"]
  Jinda::Xmain.create service: service,
                      start:   Time.zone.now,
                      name:    service.name,
                      ip:      get_ip,
                      status:  "I", # init
                      user:    current_ma_user,
                      xvars:   {
                        service_id:        service.id,
                        p:                 params.to_unsafe_h,
                        id:                params[:id],
                        user_id:           current_ma_user.try(:id),
                        custom_controller: custom_controller,
                        host:              request.host,
                        referer:           request.env["HTTP_REFERER"]
                      }
end

def clear_xmains
  Jinda::Xmain.where(status: {"$in" => %w[R I]}).update_all(status: "X")
  redirect_to action: "pending"
end

def ajax_notice
  if (notice = Jinda::Notice.recent(current_ma_user, request.env["REMOTE_ADDR"]))
    notice.update_attribute :unread, false
    js = "notice('#{notice.message}');"
  else
    js = ""
  end
  render plain: "<script>#{js}</script>"
end
