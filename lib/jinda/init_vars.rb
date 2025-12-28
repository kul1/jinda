# frozen_string_literal: true

def init_vars_by_runseq(runseq_id)
  @runseq         = Jinda::Runseq.find runseq_id
  @xmain          = @runseq.xmain
  @xvars          = @xmain.xvars
  # @xvars[:current_step]= @runseq.rstep
  @runseq.start ||= Time.zone.now
  @runseq.status  = "R" # running
  @runseq.save
end

def init_vars(xmain)
  @xmain                 = Jinda::Xmain.find xmain
  @xvars                 = @xmain.xvars
  @runseq                = @xmain.runseqs.find @xmain.current_runseq
  #    authorize?
  @xvars["current_step"] = @runseq.rstep
  @xvars["referrer"]     = request.referer
  session[:xmain_id]     = @xmain.id
  session[:runseq_id]    = @runseq.id
  unless params[:action] == "run_call"
    @runseq.start ||= Time.zone.now
    @runseq.status  = "R" # running
    @runseq.save
  end
  $xmain                 = @xmain
  $xvars                 = @xvars
  $runseq_id             = @runseq.id
  $user_id               = current_ma_user.try(:id)
end

def init_vars_by_runseq(runseq_id)
  @runseq         = Jinda::Runseq.find runseq_id
  @xmain          = @runseq.xmain
  @xvars          = @xmain.xvars
  # @xvars[:current_step]= @runseq.rstep
  @runseq.start ||= Time.zone.now
  @runseq.status  = "R" # running
  @runseq.save
end
