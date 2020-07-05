require 'active_support'
require 'active_support/core_ext'

# -*- encoding : utf-8 -*-
# This helper handle 
# 1. Read xml from mm file to run core program: 
#   process_services
# 2. Update Models, Services, Runseqs from index.mm (XML)
# 3. Rake Task to create app models, views and controller from index.mm(updated)
#
# What is xmain, runseq and xvar ?
# 
# |----  xmain 1 -----|
#  runseq1    runseq2
#
# Let make analogy or example compare with Invoicing
# Each xmain is like each invoice header
# Each invoice detail is like runseq
# So, There are only certain number of services limit in freemind index.mm
# But xmain will increase when entering each menu (services) and will increase along with activities by each user just like log file
#  
# 
# xvar is (become) global variable of current program including user, runseq, and services
#
########################################################################]


module Jinda
  module Helpers
    require "rexml/document"
    include REXML
    # methods from application_controller

    ########################################################################]
    # Each Service at one moment will create one xmain
    ########################################################################]
    def create_xmain(service)
      c = name2camel(service.module.code)
      custom_controller= "#{c}Controller"
      params["return"] = request.env['HTTP_REFERER']
      Jinda::Xmain.create :service=>service,
        :start=>Time.now,
        :name=>service.name,
        :ip=> get_ip,
        :status=>'I', # init
        :user=>current_ma_user,
        :xvars=> {
          :service_id=>service.id,
          :p=>params.to_unsafe_h,
          :id=>params[:id],
          :user_id=>current_ma_user.try(:id),
          :custom_controller=>custom_controller,
          :host=>request.host,
          :referer=>request.env['HTTP_REFERER']
        }
    end
    def clear_xmains
      Jinda::Xmain.where(:status =>{'$in'=>['R','I']}).update_all(:status=>'X')
      redirect_to action:"pending"
    end
    def ajax_notice
      if notice=Jinda::Notice.recent(current_ma_user, request.env["REMOTE_ADDR"])
        notice.update_attribute :unread, false
        js = "notice('#{notice.message}');"
      else
        js = ""
      end
      render plain: "<script>#{js}</script>"
    end

    ########################################################################]
    #  Each xmain  will create many run_seq as many as steps and form_steps 
    ########################################################################]
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
    ########################################################################]

    def create_runseq(xmain)
      @xvars= xmain.xvars
      default_role= get_default_role
      xml= xmain.service.xml
      root = REXML::Document.new(xml).root
      i= 0; j= 0 # i= step, j= form_step
      root.elements.each('node') do |activity|
        text= activity.attributes['TEXT']
        next if ma_comment?(text)
        next if text =~/^rule:\s*/
        action= freemind2action(activity.elements['icon'].attributes['BUILTIN']) if activity.elements['icon']
        return false unless action
        i= i + 1
        output_ma_display= false
        if action== ('output'|| 'list' ||'folder')
          ma_display= get_option_xml("display", activity)
          if ma_display && !affirm(ma_display)
            output_ma_display= false
          else
            output_ma_display= true
          end
        end
        j= j + 1 if (action=='form' || output_ma_display)
        @xvars['referer'] = activity.attributes['TEXT'] if action=='redirect'
        if action!= 'if' && !text.blank?
          scode, name= text.split(':', 2)
          name ||= scode; name.strip!
          code= name2code(scode)
        else
          code= text
          name= text
        end
        role= get_option_xml("role", activity) || default_role
        rule= get_option_xml("rule", activity) || "true"
        runseq= Jinda::Runseq.create :xmain=>xmain.id,
          :name=> name, :action=> action,
          :code=> code, :role=>role.upcase, :rule=> rule,
          :rstep=> i, :form_step=> j, :status=>'I',
          :xml=>activity.to_s
        xmain.current_runseq= runseq.id if i==1
      end
      @xvars['total_steps']= i
      @xvars['total_form_steps']= j
    end

    def init_vars(xmain)
      @xmain= Jinda::Xmain.find xmain
      @xvars= @xmain.xvars
      @runseq= @xmain.runseqs.find @xmain.current_runseq
      #    authorize?
      @xvars['current_step']= @runseq.rstep
      @xvars['referrer']= request.referrer
      session[:xmain_id]= @xmain.id
      session[:runseq_id]= @runseq.id
      unless params[:action]=='run_call'
        @runseq.start ||= Time.now
        @runseq.status= 'R' # running
        @runseq.save
      end
      $xmain= @xmain; $xvars= @xvars
      $runseq_id= @runseq.id
      $user_id= current_ma_user.try(:id)
    end
    def init_vars_by_runseq(runseq_id)
      @runseq= Jinda::Runseq.find runseq_id
      @xmain= @runseq.xmain
      @xvars= @xmain.xvars
      #@xvars[:current_step]= @runseq.rstep
      @runseq.start ||= Time.now
      @runseq.status= 'R' # running
      @runseq.save
    end

    def b(s)
      "<b>#{s}</b>".html_safe
    end
    def link_to_blank(body, url_options = {}, html_options = {})
      link_to(body, url_options, html_options.merge(target: "_blank"))
    end
    def code_text(s) # old def code(s)
      "<pre style='background-color: #efffef;'><code class='ruby' lang='ruby'>#{s}</code></pre>".html_safe
    end

    def refresh_to(url='/', option={})
      if option[:alert]
        ma_log option[:alert]
      end
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
      File.open path, "rb" do |f| f.read end
    end
    def redirect_to_root
      redirect_to root_path
    end

    # Todo refactor code
    def get_option(opt, runseq=@runseq)
      xml= REXML::Document.new(runseq.xml).root
      url=''
      # get option from second element of node using '//node'
      xml.each_element('//node') do |n|
        if n.attributes['TEXT']
          text = n.attributes['TEXT']
          url= text if text =~ /^#{opt}:\s*/
        end
      end
      return nil if url.blank?
      c, h= url.split(':', 2)
      opt= h ? h.strip : false
    end
    def ma_comment?(s)
      s[0]==35
    end
    def get_ip
      request.env['HTTP_X_FORWARDED_FOR'] || request.env['REMOTE_ADDR']
    end
    def get_default_role
      default_role= Jinda::Role.where(:code =>'default').first
      return default_role ? default_role.name.to_s : ''
    end

    def sign_in?
      if current_ma_user.present?
        return true
      else
        return false
      end
    end

    # ############################### Themes ###################################
    #
    # Check login user information from User model: name(code), image for Themes
    #
    # ##########################################################################
    def get_login_user_info
      if current_ma_user.present?
        $user_image = current_ma_user.image
        $user_name = current_ma_user.code
        $user_email = current_ma_user.email
        $user_id = current_ma_user.try(:id)
      else
        $user_image = asset_url("user.png", :width => "48")
        $user_name = 'Guest User'
        $user_email = 'guest@sample.com'
        $user_id = ''
      end
      return $user_image, $user_name, $user_email,$user_id
    end

    def name2code(s)
      # rather not ignore # symbol cause it could be comment
      code, name = s.split(':')
      code.downcase.strip.gsub(' ','_').gsub(/[^#_\/a-zA-Z0-9]/,'')
    end
    def name2camel(s)
      s.gsub(' ','_').camelcase
    end
    def true_action?(s)
      %w(call ws redirect invoke email).include? s
    end
    def set_global
      $xmain= @xmain ; $runseq = @runseq ; $user = current_ma_user ; $xvars= @xmain.xvars; $ip = request.env["REMOTE_ADDR"]
    end
    def authorize? # use in pending tasks
      @runseq= @xmain.runseqs.find @xmain.current_runseq
      return false unless @runseq
      @user = current_ma_user
      set_global
      return false unless eval(@runseq.rule) if @runseq.rule
      return true if true_action?(@runseq.action)
      # return false if check_wait
      return true if @runseq.role.blank?
      unless @runseq.role.empty?
        return false unless @user.role
        return @user.role.upcase.split(',').include?(@runseq.role.upcase)
      end
      return true
    end
    def authorize_init? # use when initialize new transaction
      # check module role
      mrole = @service.module.role
      return false if mrole && !current_ma_user
      return false if mrole && !current_ma_user.has_role(mrole)

      # check step 1 role
      xml= @service.xml
      step1 = REXML::Document.new(xml).root.elements['node']
      role= get_option_xml("role", step1) || ""
      #    rule= get_option_xml("rule", step1) || true
      rule= get_option_xml("rule", step1) || true
      return true if role==""
      unless current_ma_user
        return role.blank?
      else
        return false unless current_ma_user.role
        return current_ma_user.has_role(role)
      end

    end
    def ma_log(message)
      #  Jinda::Notice.create :message => ERB::Util.html_escape(message.gsub("`","'")),
      #    :unread=> true, :ip=> ($ip || request.env["REMOTE_ADDR"])
      if session[:user_id]
        Jinda::Notice.create :message => ERB::Util.html_escape(message.gsub("`","'")),
          :user_id => $user.id, :unread=> true, :ip=>request.env["REMOTE_ADDR"]
      else
        Jinda::Notice.create :message => ERB::Util.html_escape(message.gsub("`","'")),
          :unread=> true, :ip=>request.env["REMOTE_ADDR"]
      end
    end

    alias :ma_notice :ma_log

    # methods from application_helper
    def markdown(text)
      erbified = ERB.new(text.html_safe).result(binding)
      red = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
      red.render(erbified).html_safe
    end
    def align_text(s, pixel=3)
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
      role= Jinda::Role.where(code:code).first
      return role ? role.name : ""
    end
    def uncomment(s)
      s.sub(/^#\s/,'')
    end
    def code_div(s)
      "<pre style='background-color: #efffef;'><code class='ruby' lang='ruby'>    #{s}</code></pre>".html_safe
    end
    def ajax?(s)
      return s.match('file_field') ? false : true
    end
    def step(s, total) # square text
      s = (s==0)? 1: s.to_i
      total = total.to_i
      out ="<div class='step'>"
      (s-1).times {|ss| out += "<span class='steps_done'>#{(ss+1)}</span>" }
      out += %Q@<span class='step_now' >@
      out += s.to_s
      out += "</span>"
      out += %Q@@
      for i in s+1..total
        out += "<span class='steps_more'>#{i}</span>"
      end
      out += "</div>"
      out.html_safe
    end

    def current_ma_user
      # if session[:user_id]
      #   return @user ||= User.find(session[:user_id]['$oid'])
      # else
      #   return nil
      # end
      #@user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
      @user ||= User.where(:auth_token => cookies[:auth_token]).first if cookies[:auth_token]
      return @user
    end

    def ui_action?(s)
      %w(form output mail pdf).include? s
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

    # ##########################################################################
    #
    # Create / Update Modules, Runseqs, Services from XML
    #
    # ##########################################################################
    def process_services
      # todo: persist mm_md5
      xml= @app||get_app
      if defined? session
        md5= Digest::MD5.hexdigest(xml.to_s)
        if session[:mm_md5]
          return if session[:mm_md5]==md5
        else
          session[:mm_md5]= md5
        end
      end
      protected_services = []
      protected_modules = []
      mseq= 0
      @services= xml.elements["//node[@TEXT='services']"] || REXML::Document.new
      @services.each_element('node') do |m|
        # get icon for service menu
        ss= m.attributes["TEXT"]
        code, name= ss.split(':', 2)
        next if code.blank?
        next if code.comment?
        module_code= code.to_code
        menu_icon = m_icon(m)

        # ##########################################################################
        # First Node eg: Module Name 
        # ##########################################################################
        # create or update to GmaModule
        ma_module= Jinda::Module.find_or_create_by :code=>module_code
        ma_module.update_attributes :uid=>ma_module.id.to_s, :icon=>menu_icon
        protected_modules << ma_module.uid
        name = module_code if name.blank?
        ma_module.update_attributes :name=> name.strip, :seq=> mseq
        mseq += 1
        seq= 0

        # ##########################################################################
        # Second Nodes eg: Role, Link otherwise Services
        # ##########################################################################
        m.each_element('node') do |s|
          service_name= s.attributes["TEXT"].to_s
          scode, sname= service_name.split(':', 2)
          sname ||= scode; sname.strip!
          scode= scode.to_code
          if scode=="role"
            ma_module.update_attribute :role, sname
            next
          end
          if scode.downcase=="link"
            role= get_option_xml("role", s) || ""
            rule= get_option_xml("rule", s) || ""
            ma_service= Jinda::Service.find_or_create_by :module_code=> ma_module.code, :code=> scode, :name=> sname
            ma_service.update_attributes :xml=>s.to_s, :name=>sname,
              :list=>listed(s), :ma_secured=>ma_secured?(s),
              :module_id=>ma_module.id, :seq => seq,
              :confirm=> get_option_xml("confirm", xml),
              :role => role, :rule => rule, :uid=> ma_service.id.to_s
            seq += 1
            protected_services << ma_service.uid
          else

            # ##########################################################################
            # Second and Third Nodes eg: Role, Normal Services
            # ##########################################################################
            # normal service
            step1 = s.elements['node']
            role= get_option_xml("role", step1) || ""
            rule= get_option_xml("rule", step1) || ""
            ma_service= Jinda::Service.find_or_create_by :module_code=> ma_module.code, :code=> scode
            ma_service.update_attributes :xml=>s.to_s, :name=>sname,
              :list=>listed(s), :ma_secured=>ma_secured?(s),
              :module_id=>ma_module.id, :seq => seq,
              :confirm=> get_option_xml("confirm", xml),
              :role => role, :rule => rule, :uid=> ma_service.id.to_s
            seq += 1
            protected_services << ma_service.uid
          end
        end
      end
      Jinda::Module.not_in(:uid=>protected_modules).delete_all
      Jinda::Service.not_in(:uid=>protected_services).delete_all
    end

    # ##########################################################################
    #                         Load index.mm from Rails
    # ##########################################################################
    def get_app
      # MM was defined in Rails: config/initializer/jinda.rb
      f= MM || "#{Rails.root}/app/jinda/index.mm" 
      dir= File.dirname(f)
      t= REXML::Document.new(File.read(MM).gsub("\n","")).root
      recheck= true ; first_pass= true
      while recheck
        recheck= false
        t.elements.each("//node") do |n|
          if n.attributes['LINK'] # has attached file
            if first_pass
              f= "#{dir}/#{n.attributes['LINK']}"
            else
              f= n.attributes['LINK']
            end
            next unless File.exists?(f)
            tt= REXML::Document.new(File.read(f).gsub("\n","")).root.elements["node"]
            make_folders_absolute(f,tt)
            tt.elements.each("node") do |tt_node|
              n.parent.insert_before n, tt_node
            end
            recheck= true
            n.parent.delete_element n
          end
        end
        first_pass = false
      end
      return t
    end

    ########################################################################
    #                            Jinda Rake Task                           #
    ########################################################################

    def gen_views
      t = ["*** generate ui ***"]

      # create array of files to be tested
      $afile = Array.new

      Jinda::Module.all.each do |m|
        m.services.each do |s|
          dir ="app/views/#{s.module.code}"
          unless gen_view_file_exist?(dir)
            gen_view_mkdir(dir,t) 
          end

          if s.code=='link'
            f= "app/views/#{s.module.code}/index.haml"
            $afile << f
            unless gen_view_file_exist?(f)
              sv = "app/jinda/template/linkview.haml"
              f= "app/views/#{s.module.code}/index.haml"
              gen_view_createfile(sv,f,t)
            end
            next   
          end

          dir ="app/views/#{s.module.code}/#{s.code}"
          unless gen_view_file_exist?(dir)
            gen_view_mkdir(dir,t) 
          end

          xml= REXML::Document.new(s.xml)
          xml.elements.each('*/node') do |activity|
            icon = activity.elements['icon']
            next unless icon
            action= freemind2action(icon.attributes['BUILTIN'])
            next unless ui_action?(action)
            code_name = activity.attributes["TEXT"].to_s
            next if code_name.comment?
            code= name2code(code_name)
            if action=="pdf"
              f= "app/views/#{s.module.code}/#{s.code}/#{code}.pdf.prawn"
            else
              f= "app/views/#{s.module.code}/#{s.code}/#{code}.html.erb"
            end
            $afile << f
            unless gen_view_file_exist?(f)
              sv = "app/jinda/template/view.html.erb"
              gen_view_createfile(sv,f,t)
            end
          end
        end
      end
      puts $afile.join("\n")
      puts t.join("\n")
      return $afile  
    end

    def process_controllers
      process_services
      modules= Jinda::Module.all
      modules.each do |m|
        next if controller_exists?(m.code)
        system("rails generate controller #{m.code}")
      end
    end

    def process_models

      # app= get_app
      # t= ["process models"]
      #  xml map sample from index.mm 
      #   node @CREATED=1273819432637 @ID=ID_1098419600 @MODIFIED=1334737006485 @TEXT=Jinda 
      #    node @CREATED=1273819462973 @ID=ID_282419531 @MODIFIED=1493705904561 @POSITION=right @TEXT=services 
      #     node @CREATED=1273819465949 @FOLDED=true @ID=ID_855471610 @MODIFIED=1493768913078 @POSITION=right @TEXT=roles 
      #      node @CREATED=1273819456867 @ID=ID_1677010054 @MODIFIED=1493418874718 @POSITION=left @TEXT=models 
      #       node @CREATED=1292122118499 @FOLDED=true @ID=ID_1957754752 @MODIFIED=1493705885123 @TEXT=person 
      #       node @CREATED=1292122236285 @FOLDED=true @ID=ID_959987887 @MODIFIED=1493768919147 @TEXT=address 
      #       node @CREATED=1493418879485 @ID=ID_1995497233 @MODIFIED=1493718770637 @TEXT=article 
      #       node @CREATED=1493418915637 @ID=ID_429078131 @MODIFIED=1493418930081 @TEXT=comment 

      models= @app.elements["//node[@TEXT='models']"] || REXML::Document.new
      models.each_element('node') do |model|
        # t << "= "+model.attributes["TEXT"]
        model_name= model.attributes["TEXT"]
        next if model_name.comment?
        model_code= name2code(model_name)
        model_file= "#{Rails.root}/app/models/#{model_code}.rb"

        if File.exists?(model_file)
          doc= File.read(model_file)
        else
          system("rails generate model #{model_code}")
          doc= File.read(model_file)
        end

        doc = add_utf8(doc)
        attr_hash= make_fields(model)
        doc = add_jinda(doc, attr_hash)
        # t << "modified:   #{model_file}"
        File.open(model_file, "w") do |f|
          f.puts doc
        end

      end

      # puts t.join("\n")
    end

    def add_jinda(doc, attr_hash)
      if doc =~ /#{@btext}/
        s1,s2,s3= doc.partition(/  #{@btext}.*#{@etext}\n/m)
          s2= ""
      else
        s1,s2,s3= doc.partition("include Mongoid::Document\n")
      end
      doc= s1+s2+ <<-EOT
  #{@btext}
  include Mongoid::Timestamps
      EOT

      attr_hash.each do |a|
        # doc+= "\n*****"+a.to_s+"\n"
        if a[:edit]
          doc += "  #{a[:text]}\n"
        else
          doc += "  field :#{a[:code]}, :type => #{a[:type].capitalize}\n"
        end
      end
      doc += "  #{@etext}\n"
      doc + s3
    end

    def add_utf8(doc)
      unless doc =~ /encoding\s*:\s*utf-8/
        doc.insert 0, "# encoding: utf-8\n"
      else
        doc
      end
    end

    # inspect all nodes that has attached file (2 cases) and replace relative path with absolute path
    def make_folders_absolute(f,tt)
      tt.elements.each("//node") do |nn|
        if nn.attributes['LINK']
          nn.attributes['LINK']= File.expand_path(File.dirname(f))+"/#{nn.attributes['LINK']}"
        end
      end
    end

    def name2code(s)
      # rather not ignore # symbol cause it could be comment
      code, name = s.split(':')
      code.downcase.strip.gsub(' ','_').gsub(/[^#_\/a-zA-Z0-9]/,'')
    end

    def model_exists?(model)
      File.exists? "#{Rails.root}/app/models/#{model}.rb"
    end

    def make_fields(n)
      # s= field string used by generate model cli (old style jinda)
      s= ""
      # h= hash :code, :type, :edit, :text
      h= []
      n.each_element('node') do |nn|
        text = nn.attributes['TEXT']
        icon = nn.elements['icon']
        edit= (icon && icon.attribute('BUILTIN').value=="edit")
        next if text.comment? && !edit

        # sometimes freemind puts all fields inside a blank node
        unless text.empty?
          k,v= text.split(/:\s*/,2)
          v ||= 'string'
          v= 'float' if v=~/double/i
          s << " #{name2code(k.strip)}:#{v.strip} "
          h << {:code=>name2code(k.strip), :type=>v.strip, :edit=>edit, :text=>text}
        else
          nn.each_element('node') do |nnn|
            icon = nnn.elements['icon']
            edit1= (icon && icon.attribute('BUILTIN').value=="edit")
            text1 = nnn.attributes['TEXT']
            next if text1 =~ /\#.*/
            k,v= text1.split(/:\s*/,2)
            v ||= 'string'
            v= 'float' if v=~/double/i
            s << " #{name2code(k.strip)}:#{v.strip} "
            h << {:code=>name2code(k.strip), :type=>v.strip, :edit=>edit1, :text=>text1}
          end
        end
      end
      # f
      h
    end

    # Add method to ruby class String
    # ###############################
    class String
      def comment?
        self[0]=='#'
        # self[0]==35 # check if first char is #
      end
      def to_code
        s= self.dup
        s.downcase.strip.gsub(' ','_').gsub(/[^#_\/a-zA-Z0-9]/,'')
      end
    end

    ########################################################################
    #                     END  code from jinda.rake                        #
    ########################################################################


    ########################################################################
    #                  Methods to be overrided by gemhelp                  #
    #                            for Rspec Test
    ########################################################################
    def gen_view_file_exist?(dir)
      File.exists?(dir)
    end

    def gen_view_mkdir(dir,t)
      Dir.mkdir(dir)
      t << "create directory #{dir}"
    end

    def gen_view_createfile(s,f,t)
      FileUtils.cp s,f
      # FileUtils.cp "app/jinda/template/linkview.haml",f
      t << "create file #{f}"
    end
    ########################################################################

    def controller_exists?(modul)
      File.exists? "#{Rails.root}/app/controllers/#{modul}_controller.rb"
    end
    def dup_hash(a)
      h = Hash.new(0)
      a.each do |aa|
        h[aa] += 1
      end
      return h
    end
    def login?
      ## To use remember me cookies then remove
      #session[:user_id] != nil
      current_ma_user != nil
      #cookies[:auth_token] != nil
    end
    def own_xmain?
      if $xmain
        return current_ma_user.id==$xvars['user_id']
      else
        # if eval on first step would return true so user can start service
        return true
      end
    end
    # return nil or value of opt: if provided
    def get_option_xml(opt, xml)
      if xml
        url=''
        xml.each_element('node') do |n|
          text= n.attributes['TEXT']
          # check if opt match from beginning of text
          url= text if text =~/^#{opt}/
        end
        return nil if url.blank?
        c, h= url.split(':', 2)
        opt= h ? h.strip : true
      else
        return nil
      end
    end
    def m_icon(node)
      mcons=[]
      node.each_element("icon") do |mn|
        mcons << mn.attributes["BUILTIN"]
      end
      ticon = mcons[0].to_s
      return ticon
    end

    # Option to unlisted in the menu_mm if icon 'button_cancel'
    def listed(node)
      icons=[]
      node.each_element("icon") do |nn|
        icons << nn.attributes["BUILTIN"]
      end

      return !icons.include?("button_cancel")
    end
    def ma_secured?(node)
      icons=[]
      node.each_element("icon") do |nn|
        icons << nn.attributes["BUILTIN"]
      end
      return icons.include?("password")
    end
    def ma_menu?
      icons=[]
      node.each_element("icon") do |mn|
        icons << mn.attributes["BUILTIN"]
      end
      return icons.include?("menu")
    end

    def freemind2action(s)
      case s.downcase
        #when 'bookmark' # Excellent
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
      when 'kaddressbook' #Phone
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
      return s =~ /[y|yes|t|true]/i ? true : false
    end
    def negate(s)
      return s =~ /[n|no|f|false]/i ? true : false
    end

    # module FormBuilder
    #   def date_field(method, options = {})
    #     default= self.object.send(method) || Date.today
    #     data_options= ({"mode"=>"calbox"}).merge(options)
    #     %Q(<input name='#{self.object_name}[#{method}]' id='#{self.object_name}_#{method}' value='#{default.strftime("%F")}' type='date' data-role='datebox' data-options='#{data_options.to_json}'>).html_safe
    #   end
    # end
  end
end

class String
  #
  # Put comment in freemind with #
  # Sample Freemind
  # #ctrs:ctrs&Menu
  #
  def comment?
    self[0]=='#'
  end
  def to_code
    s= self.dup
    #    s.downcase!
    #    s.gsub! /[\s\-_]/, ""
    #    s
    code, name = s.split(':')
    code.downcase.strip.gsub(' ','_').gsub(/[^#_\/a-zA-Z0-9]/,'')
  end
end

module ActionView
  module Helpers
    module DateHelper
      def date_field_tag(method, options = {})
        default= options[:default] || Date.today
        data_options= ({"mode"=>"calbox"}).merge(options)
        %Q(<input name='#{method}' id='#{method}' value='#{default.strftime("%F")}' type='date' data-role='datebox' data-options='#{data_options.to_json}'>).html_safe
      end
    end
    class FormBuilder
      def date_select_thai(method)
        self.date_select method, :use_month_names=>THAI_MONTHS, :order=>[:day, :month, :year]
      end
      def date_field(method, options = {})
        default= options[:default]  || self.object.send(method) || Date.today
        data_options= ({"mode"=>"calbox"}).merge(options)
        out= %Q(<input name='#{self.object_name}[#{method}]' id='#{self.object_name}_#{method}' value='#{default.strftime("%F")}' type='date' data-role='datebox' data-options='#{data_options.to_json}'>)
        out.html_safe
      end
      def time_field(method, options = {})
        default= self.object.send(method) || Time.now
        data_options= ({"mode"=>"timebox"}).merge(options)
        out=%Q(<input name='#{self.object_name}[#{method}]' id='#{self.object_name}_#{method}' value='#{default}' type='date' data-role='datebox' data-options='#{data_options.to_json}'>)
        out.html_safe
      end
      def date_select_thai(method, default= Time.now, disabled=false)
        date_select method, :default => default, :use_month_names=>THAI_MONTHS, :order=>[:day, :month, :year], :disabled=>disabled
      end
      def datetime_select_thai(method, default= Time.now, disabled=false)
        datetime_select method, :default => default, :use_month_names=>THAI_MONTHS, :order=>[:day, :month, :year], :disabled=>disabled
      end

      def point(o={})
        o[:zoom]= 11 unless o[:zoom]
        o[:width]= '100%' unless o[:width]
        o[:height]= '300px' unless o[:height]
        o[:lat] = 13.91819 unless o[:lat]
        o[:lng] = 100.48889 unless o[:lng]

        out = <<-EOT
  <script type='text/javascript'>
  //<![CDATA[
    var latLng;
    var map_#{self.object_name};
    var marker_#{self.object_name};

    function init_map() {
      var lat =  #{o[:lat]};
      var lng =  #{o[:lng]};
      //var lat =  position.coords.latitude"; // HTML5 pass position in function initialize(position)
      // google.loader.ClientLocation.latitude;
      //var lng =  position.coords.longitude;
      // google.loader.ClientLocation.longitude;
      latLng = new google.maps.LatLng(lat, lng);
      map_#{self.object_name} = new google.maps.Map(document.getElementById("map_#{self.object_name}"), {
        zoom: #{o[:zoom]},
        center: latLng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      });
      marker_#{self.object_name} = new google.maps.Marker({
        position: latLng,
        map: map_#{self.object_name},
        draggable: true,
      });
      google.maps.event.addListener(marker_#{self.object_name}, 'dragend', function(event) {
        $('##{self.object_name}_lat').val(event.latLng.lat());
        $('##{self.object_name}_lng').val(event.latLng.lng());
      });
      google.maps.event.addListener(map_#{self.object_name}, 'click', function(event) {
        $('##{self.object_name}_lat').val(event.latLng.lat());
        $('##{self.object_name}_lng').val(event.latLng.lng());
        move();
      });
      $('##{self.object_name}_lat').val(lat);
      $('##{self.object_name}_lng').val(lng);
    };

    function move() {
      latLng = new google.maps.LatLng($('##{self.object_name}_lat').val(), $('##{self.object_name}_lng').val());
      map_#{self.object_name}.panTo(latLng);
      marker_#{self.object_name}.setPosition(latLng);
    }

    //google.maps.event.addDomListener(window, 'load', init_map);

  //]]>
  </script>
  <div class="field" data-role="fieldcontain">
    Latitude: #{self.text_field :lat, :style=>"width:300px;" }
    Longitude: #{self.text_field :lng, :style=>"width:300px;" }
  </div>
  <p/>
  <div id='map_#{self.object_name}' style='max-width: none !important; width:#{o[:width]}; height:#{o[:height]};' class='map'></div>
  <script>
    $('##{self.object_name}_lat').change(function() {move()});
    $('##{self.object_name}_lng').change(function() {move()});
    //var w= $("input[id*=lat]").parent().width();
    //$("input[id*=lat]").css('width','300px');
    //$("input[id*=lng]").css('width','300px');
    $( document ).one( "pagechange", function(){
      init_map();
    });
  </script>
        EOT
        out.html_safe
      end
    end
  end
end
