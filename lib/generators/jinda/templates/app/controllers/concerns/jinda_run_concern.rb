module JindaRunConcern
  extend ActiveSupport::Concern

  def run_form
    init_vars(params[:id])
    if authorize?
      if ['F', 'X'].include? @xmain.status
        redirect_to_root
      else
        service= @xmain.service
        ###############################################################################################
        # Run View Form f created template by jinda rake follow freemind mm file
        ###############################################################################################
        if service
          @title= "Transaction ID #{@xmain.xid}: #{@xmain.name} / #{@runseq.name}"
          fhelp= "app/views/#{service.module.code}/#{service.code}/#{@runseq.code}.md"
          ###############################################################################################
          # Check if help file available for this form
          ###############################################################################################
          @help = File.read(fhelp) if File.exists?(fhelp)
          f= "app/views/#{service.module.code}/#{service.code}/#{@runseq.code}.html.erb"
          if File.file?(f)
            @ui= File.read(f)
          else
            # flash[:notice]= "Error: Can not find the view file for this controller"
            ma_log "Error: Can not find the view file for this controller"
            redirect_to_root
          end
        end
        init_vars(params[:id])
      end
    else
      redirect_to_root
    end
  end

  def run_if
    init_vars(params[:id])
    condition= eval(@runseq.code).to_s
    match_found= false
    if condition
      xml= REXML::Document.new(@runseq.xml).root
      next_runseq= nil
      text = xml.elements['//node/node'].attributes['TEXT']
      match, name= text.split(':',2)
      label= name2code(name.strip)
      if condition==match
        if label=="end"
          @end_job= true
        else
          next_runseq= @xmain.runseqs.where(:code=> label, :action.ne=>'redirect').first
          match_found= true if next_runseq
          @runseq_not_f= false
        end
      end
    end
    unless match_found || @end_job
      next_runseq= @xmain.runseqs.where( rstep:(@xvars['current_step']+1) ).first
    end
    end_action(next_runseq)
  end

  # redirect when finish last runseq
  # eg: http://localhost:3000/notes/my
  def run_direct_to
    init_vars(params[:id])
    next_runseq= @xmain.runseqs.where(:id.ne=>@runseq.id, :code=>@runseq.code).first
    if !@runseq.code.blank? 
      @xvars['p']['return'] = @runseq.code
    else
      flash[:notice]= "Error: missing required forward path in Freemind"
      ma_log "Error: require forward path in Freemind"
    end
    end_action(next_runseq)
  end

  def run_redirect
    init_vars(params[:id])
    # next_runseq= @xmain.runseqs.first :conditions=>["id != ? AND code = ?",@runseq.id, @runseq.code]
    next_runseq= @xmain.runseqs.where(:id.ne=>@runseq.id, :code=>@runseq.code).first
    @xmain.current_runseq= next_runseq.id
    end_action(next_runseq)
  end

    # call controller to do the freemind task using Star symbol eg: Update
    # not for run_form
  def run_do
    init_vars(params[:id])
    @runseq.start ||= Time.now
    @runseq.status= 'R' # running
    $runseq_id= @runseq.id
    $user_id= current_ma_user.try(:id)
    # $xmain, $runseq, $user, $xvars, $ip from local
    set_global
    controller = Kernel.const_get(@xvars['custom_controller']).new
    result = controller.send(@runseq.code)
    # save local var to database
    init_vars_by_runseq($runseq_id)
    @xvars = $xvars
    @xvars[@runseq.code.to_sym]= result.to_s
    @xvars['current_step']= @runseq.rstep
    @runseq.status= 'F' #finish
    @runseq.stop= Time.now
    @runseq.save
    end_action
  rescue => e
    @xmain.status='E'
    @xvars['error']= e.to_s+e.backtrace.to_s
    @xmain.xvars= $xvars
    @xmain.save
    @runseq.status= 'F' #finish
    @runseq.stop= Time.now
    @runseq.save
    refresh_to "/", :alert => "Sorry opeation error at  #{@xmain.id} #{@xvars['error']}"
  end

  def run_list
    init_vars(params[:id])
    service= @xmain.service
    # disp= get_option("display")
    # disp = Nil or :"??????"
    # get option from last node: rule, role, display
    disp= get_option("display")
    # change from Nil to false and string to true
    ma_display = (disp && !affirm(disp)) ? false : true
    # Todo check if file is available
    # if service and file exist
    # ma_display from disp of 3rd level node as rule, role, display
    if service && !@runseq.code.blank? 
      f= "app/views/#{service.module.code}/#{service.code}/#{@runseq.code}.html.erb"
      @ui= File.read(f)
      if Jinda::Doc.where(:runseq_id=>@runseq.id).exists?
        @doc= Jinda::Doc.where(:runseq_id=>@runseq.id).first
        @doc.update_attributes :data_text=> render_to_string(:inline=>@ui, :layout=>"utf8"),
          :xmain=>@xmain, :runseq=>@runseq, :user=>current_ma_user,
          :ip=> get_ip, :service=>service, :ma_display=>ma_display,
          :ma_secured => @xmain.service.ma_secured,
          :filename => "#{@runseq.code}.html.erb"
      else
        @doc= Jinda::Doc.create :name=> @runseq.name,
          :content_type=>"output", :data_text=> render_to_string(:inline=>@ui, :layout=>"utf8"),
          :xmain=>@xmain, :runseq=>@runseq, :user=>current_ma_user,
          :ip=> get_ip, :service=>service, :ma_display=>ma_display,
          :ma_secured => @xmain.service.ma_secured,
          :filename => "#{@runseq.code}.html.erb"
      end
      # @message = defined?(MSG_NEXT) ? MSG_NEXT : "Next &gt;"
      @message = defined?(MSG_NEXT) ? MSG_NEXT : "Next >>"
      @message = "Finish" if @runseq.end
      ma_log("Todo defined?(NSG_NEXT : Next >>)")
      eval "@xvars[@runseq.code] = url_for(:controller=>'jinda', :action=>'document', :id=>@doc.id)"
    else
      flash[:notice]= "Error: Can not find the view file for this controller"
      ma_log "Error: Can not find the view file for this controller"
      redirect_to_root
    end
    # Check if ma_display available
    # ma_display= get_option("display")
    # if not ma_display then no display both controller-view and content then  end back to root
    unless ma_display
      end_action
    end
    # controller display from  @ui
  end

  def run_folder
    init_vars(params[:id])
    service= @xmain.service
    # disp= get_option("display")
    # disp = Nil or :"??????"
    disp= get_option("display")
    ma_display = (disp && !affirm(disp)) ? false : true
    # Todo check if file is available
    # if service and file exist
    if service && !@runseq.code.blank? 
      f= "app/views/#{service.module.code}/#{service.code}/#{@runseq.code}.html.erb"
      @ui= File.read(f)
      if Jinda::Doc.where(:runseq_id=>@runseq.id).exists?
        @doc= Jinda::Doc.where(:runseq_id=>@runseq.id).first
        @doc.update_attributes :data_text=> render_to_string(:inline=>@ui, :layout=>"utf8"),
          :xmain=>@xmain, :runseq=>@runseq, :user=>current_ma_user,
          :ip=> get_ip, :service=>service, :ma_display=>ma_display,
          :ma_secured => @xmain.service.ma_secured,
          :filename => "#{@runseq.code}.html.erb"
      else
        @doc= Jinda::Doc.create :name=> @runseq.name,
          :content_type=>"output", :data_text=> render_to_string(:inline=>@ui, :layout=>"utf8"),
          :xmain=>@xmain, :runseq=>@runseq, :user=>current_ma_user,
          :ip=> get_ip, :service=>service, :ma_display=>ma_display,
          :ma_secured => @xmain.service.ma_secured,
          :filename => "#{@runseq.code}.html.erb"
      end
      # @message = defined?(MSG_NEXT) ? MSG_NEXT : "Next &gt;"
      @message = defined?(MSG_NEXT) ? MSG_NEXT : "Next >>"
      @message = "Finish" if @runseq.end
      ma_log("Todo defined?(NSG_NEXT : Next >>)")
      eval "@xvars[@runseq.code] = url_for(:controller=>'jinda', :action=>'document', :id=>@doc.id)"
    else
      flash[:notice]= "Error: Can not find the view file for this controller"
      ma_log "Error: Can not find the view file for this controller"
      redirect_to_root
    end
    # Check if ma_display available
    # ma_display= get_option("display")
    unless ma_display
      end_action
    end
    # controller display from  @ui
  end

  def run_output
    init_vars(params[:id])
    service= @xmain.service
    # disp= get_option("display")
    # disp = Nil or :"??????"
    disp= get_option("display")
    ma_display = (disp && !affirm(disp)) ? false : true
    # Todo check if file is available
    # if service and file exist
    if service && !@runseq.code.blank? 
      f= "app/views/#{service.module.code}/#{service.code}/#{@runseq.code}.html.erb"
      @ui= File.read(f)
      if Jinda::Doc.where(:runseq_id=>@runseq.id).exists?
        @doc= Jinda::Doc.where(:runseq_id=>@runseq.id).first
        @doc.update_attributes :data_text=> render_to_string(:inline=>@ui, :layout=>"utf8"),
          :xmain=>@xmain, :runseq=>@runseq, :user=>current_ma_user,
          :ip=> get_ip, :service=>service, :ma_display=>ma_display,
          :ma_secured => @xmain.service.ma_secured,
          :filename => "#{@runseq.code}.html.erb"
      else
        @doc= Jinda::Doc.create :name=> @runseq.name,
          :content_type=>"output", :data_text=> render_to_string(:inline=>@ui, :layout=>"utf8"),
          :xmain=>@xmain, :runseq=>@runseq, :user=>current_ma_user,
          :ip=> get_ip, :service=>service, :ma_display=>ma_display,
          :ma_secured => @xmain.service.ma_secured,
          :filename => "#{@runseq.code}.html.erb"
      end
      # @message = defined?(MSG_NEXT) ? MSG_NEXT : "Next &gt;"
      @message = defined?(MSG_NEXT) ? MSG_NEXT : "Next >>"
      @message = "Finish" if @runseq.end
      ma_log("Todo defined?(NSG_NEXT : Next >>)")
      eval "@xvars[@runseq.code] = url_for(:controller=>'jinda', :action=>'document', :id=>@doc.id)"
    else
      flash[:notice]= "Error: Can not find the view file for this controller"
      ma_log "Error: Can not find the view file for this controller"
      redirect_to_root
    end
    # Check if ma_display available
    # ma_display= get_option("display")
    unless ma_display
      end_action
    end
    # controller display from  @ui
  end

  def run_mail
    init_vars(params[:id])
    service= @xmain.service
    f= "app/views/#{service.module.code}/#{service.code}/#{@runseq.code}.html.erb"
    @ui= File.read(f).html_safe
    @doc= Jinda::Doc.create :name=> @runseq.name,
      :content_type=>"mail", :data_text=> render_to_string(:inline=>@ui, :layout=>false),
      :xmain=>@xmain, :runseq=>@runseq, :user=>current_ma_user,
      :ip=> get_ip, :service=>service, :ma_display=>false,
      :ma_secured => @xmain.service.ma_secured
    eval "@xvars[:#{@runseq.code}] = url_for(:controller=>'jinda', :action=>'document', :id=>@doc.id)"
    mail_from = get_option('from')
    # sender= render_to_string(:inline=>mail_from) if mail_from
    mail_to = get_option('to')
    recipients= render_to_string(:inline=>mail_to) if mail_to
    mail_subject = get_option('subject')
    subject= render_to_string(:inline=>mail_subject) || "#{@runseq.name}"
    JindaMailer.gmail(@doc.data_text, recipients, subject).deliver unless DONT_SEND_MAIL
    end_action
  end

  def end_output
    init_vars(params[:xmain_id])
    end_action
  end

  # Store params to @xvars[@runseq]
  # Perform task from the form input eg: attach file
  # replace end_action (for form)
  # Store params attach file to @xvars to use in get_image
  def end_form
    if params[:xmain_id]
      init_vars(params[:xmain_id])
    else
      ma_log "Known Bug : repeated end_form "
      redirect_to_root and return
    end
    eval "@xvars[@runseq.code] = {} unless @xvars[@runseq.code]"
    # Search for uploaded file name if exist
    params.each { |k,v|
      if params[k].respond_to? :original_filename
        get_image(k, params[k])
        # check if params of array in form eg: edit_article	
      elsif params[k].is_a?(ActionController::Parameters)
        eval "@xvars[@runseq.code][k] = {} unless @xvars[@runseq.code][k]"
        params[k].each { |k1,v1|
          # eval "@xvars[@runseq.code][k1] = params.require(k1).permit(k1)"
          eval "@xvars[@runseq.code][k][k1] = v1" 
          next unless v1.respond_to?(:original_filename)
          doc = {}
          get_image1(k, k1, params[k][k1])
        }
      else
        # No file attached
        #
        # https://stackoverflow.com/questions/34949505/rails-5-unable-to- retrieve-hash-values-from-parameter     # bug in to_unsalfe_h rails 5.1.6 https://github.com/getsentry/raven-ruby/issues/799
        # Solution:
        # https://stackoverflow.com/questions/34949505/rails-5-unable-to-retrieve-hash-values-from-parameter
        # v = v.to_unsafe_h unless v.class == String
        # v = params.require[k] unless v.class == String
        v = v.to_s unless v.class == String
        # Create @xvars[@runseq.code]
        eval "@xvars[@runseq.code][k] = v"
      end
    }
  end_action
  rescue => e
    @xmain.status='E'
    @xvars['error']= e.to_s+e.backtrace.to_s
    @xmain.xvars= $xvars
    @xmain.save
    @runseq.status= 'F' #finish
    @runseq.stop= Time.now
    @runseq.save
    ma_log "Error:end_form "
    refresh_to "/", :alert => "Sorry opeation error at  #{@xmain.id} #{@xvars['error']}"
  end

  def end_action(next_runseq = nil)
    # not for form
    #    @runseq.status='F' unless @runseq_not_f
    @xmain.xvars= @xvars
    @xmain.status= 'R' # running
    @xmain.save!
    @runseq.status='F'
    @runseq.user= current_ma_user
    @runseq.stop= Time.now
    @runseq.save
    next_runseq= @xmain.runseqs.where(:rstep=> @runseq.rstep+1).first unless next_runseq
    if @end_job || !next_runseq # job finish
      @xmain.xvars= @xvars
      @xmain.status= 'F' unless @xmain.status== 'E' # finish
      @xmain.stop= Time.now
      @xmain.save
      if @xvars['p']['return']
        redirect_to @xvars['p']['return'] and return
      else
        if @user
          redirect_to :action=>'index' and return
        else
          redirect_to_root and return
        end
      end
    else
      @xmain.update_attribute :current_runseq, next_runseq.id
      redirect_to :action=>'run', :id=>@xmain.id and return
    end
  end

end 
