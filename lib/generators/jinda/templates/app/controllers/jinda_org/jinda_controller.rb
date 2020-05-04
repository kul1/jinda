# -*- encoding : utf-8 -*-

class JindaController < ApplicationController
  include JindaRunConcern
  include JindaGeneralConcern
  # view menu by user selected what service (module and code) to run (not all services like menu did
  # Its only one service 

  def init
    module_code, code = params[:s].split(":")
    @service= Jinda::Service.where(:module_code=> module_code, :code=> code).first
    if @service && authorize_init?
      xmain = create_xmain(@service)
      result = create_runseq(xmain)
      unless result
        message = "cannot find action for xmain #{xmain.id}"
        ma_log(message)
        flash[:notice]= message
        redirect_to "pending" and return
      end
      xmain.update_attribute(:xvars, @xvars)
      xmain.runseqs.last.update_attribute(:end,true)
      #Above line cause error update_attribute in heroku shown in logs and it was proposed to fixed in github:'kul1/g241502'
      redirect_to :action=>'run', :id=>xmain.id
    else
      refresh_to "/", :alert => "Error: cannot process"
    end
  end

  ########################################################################]
  # run if, form, mail, output etc depend on icon in freemind
  # action from @r.action == do, form, if, output
  # Then will call def run_do, run_form, run_if, run_output
  ########################################################################]
  def run
    init_vars(params[:id])
    if authorize?
      # session[:full_layout]= false
      redirect_to(:action=>"run_#{@runseq.action}", :id=>@xmain.id)
    else
      redirect_to_root
    end
  end

end
