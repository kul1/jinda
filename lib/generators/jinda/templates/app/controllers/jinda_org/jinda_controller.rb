# -*- encoding : utf-8 -*-

class JindaController < ApplicationController
  include JindaRunConcern
  include JindaGeneralConcern

  def index
  end

  def logs
    @xmains = Jinda::Xmain.all.desc(:created_at).page(params[:page]).per(10)
  end
  def error_logs
    @xmains = Jinda::Xmain.in(status:['E']).desc(:created_at).page(params[:page]).per(10)
  end
  def notice_logs
    @notices= Jinda::Notice.desc(:created_at).page(params[:page]).per(10)
  end
  def pending
    @title= "Pending Tasks"
    @xmains = Jinda::Xmain.in(status:['R','I']).asc(:created_at)
  end
  def cancel
    Jinda::Xmain.find(params[:id]).update_attributes :status=>'X'
    if params[:return]
      redirect_to params[:return]
    else
      redirect_to action:"pending"
    end
  end

  # view menu by user selected what service (module and code) to run (not all services like menu did
  # Its only one service 
  def init
    module_code, code = params[:s].split(":")
    @service= Jinda::Service.where(:module_code=> module_code, :code=> code).first
    # @service= Jinda::Service.where(:module_code=> params[:module], :code=> params[:service]).first
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
