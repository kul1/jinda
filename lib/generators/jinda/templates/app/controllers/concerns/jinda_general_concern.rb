module JindaGeneralConcern
  # process images from first level
  def get_image(key, params)
    doc = Jinda::Doc.create(
      :name=> key.to_s,
      :xmain=> @xmain.id,
      :runseq=> @runseq.id,
      :filename=> params.original_filename,
      :content_type => params.content_type || 'application/zip',
      :data_text=> '',
      :ma_display=>true,
      :ma_secured => @xmain.service.ma_secured )
    if defined?(IMAGE_LOCATION)
      filename = "#{IMAGE_LOCATION}/f#{Param.gen(:asset_id)}"
      File.open(filename,"wb") { |f| f.write(params.read) }
      # File.open(filename,"wb") { |f| f.puts(params.read) }
      eval "@xvars[@runseq.code][key] = '#{url_for(:action=>'document', :id=>doc.id, :only_path => true )}' "
      doc.update_attributes :url => filename, :basename => File.basename(filename), :cloudinary => false
    else
      result = Cloudinary::Uploader.upload(params)
      eval %Q{ @xvars[@runseq.code][key] = '#{result["url"]}' }
      doc.update_attributes :url => result["url"], :basename => File.basename(result["url"]), :cloudinary => true
    end
  end
  # process images from second level, e.g,, fields_for
  def get_image1(key, key1, params)
    doc = Jinda::Doc.create(
      :name=> "#{key}_#{key1}",
      :xmain=> @xmain.id,
      :runseq=> @runseq.id,
      :filename=> params.original_filename,
      :content_type => params.content_type || 'application/zip',
      :data_text=> '',
      :ma_display=>true, :ma_secured => @xmain.service.ma_secured )
    if defined?(IMAGE_LOCATION)
      filename = "#{IMAGE_LOCATION}/f#{Param.gen(:asset_id)}"
      File.open(filename,"wb") { |f| f.write(params.read) }
      eval "@xvars[@runseq.code][key][key1] = '#{url_for(:action=>'document', :id=>doc.id, :only_path => true)}' "
      doc.update_attributes :url => filename, :basename => File.basename(filename), :cloudinary => false
    else
      result = Cloudinary::Uploader.upload(params)
      eval %Q{ @xvars[@runseq.code][key][key1] = '#{result["url"]}' }
      doc.update_attributes :url => result["url"], :basename => File.basename(result["url"]), :cloudinary => true
    end
  end
  def doc_print
    render :file=>'public/doc.html', :layout=>'layouts/print'
  end
  # generate documentation for application
  def doc
    require 'rdoc'
    @app= get_app
    @intro = File.read('README.md')
    @print= "<div align='right'><img src='/assets/printer.png'/> <a href='/jinda/doc_print' target='_blank'/>Print</a></div>"
    doc= render_to_string 'doc.md', :layout => false

    html= Maruku.new(doc).to_html
    File.open('public/doc.html','w') {|f| f.puts html }
    respond_to do |format|
      format.html {
        render :plain=> @print+html, :layout => 'layouts/jqm/_page'
        # render :text=> Maruku.new(doc).to_html, :layout => false
        # format.html {
        #   h = RDoc::Markup::ToHtml.new
        #   render :text=> h.convert(doc), :layout => 'layouts/_page'
      }
        format.pdf  {
          latex= Maruku.new(doc).to_latex
          File.open('tmp/doc.md','w') {|f| f.puts doc}
          File.open('tmp/doc.tex','w') {|f| f.puts latex}
          # system('pdflatex tmp/doc.tex ')
          # send_file( 'tmp/doc.pdf', :type => ‘application/pdf’,
          # :disposition => ‘inline’, :filename => 'doc.pdf')
          render :plain=>'done'
        }
    end
  end
  def status
    @xmain= Jinda::Xmain.where(:xid=>params[:xid]).first
    @title= "Task number #{params[:xid]} #{@xmain.name}"
    @backbtn= true
    @xvars= @xmain.xvars
    # flash.now[:notice]= "รายการ #{@xmain.id} ได้ถูกยกเลิกแล้ว" if @xmain.status=='X'
    ma_log "Task #{@xmain.id} is cancelled" if @xmain.status=='X'
    # flash.now[:notice]= "transaction #{@xmain.id} was cancelled" if @xmain.status=='X'
  rescue
    refresh_to "/", :alert => "Could not find task number <b> #{params[:xid]} </b>"
  end
  def help
  end
  def search
    @q = params[:q] || params[:ma_search][:q] || ""
    @title = "ผลการค้นหา #{@q}"
    @backbtn= true
    @cache= true
    if @q.blank?
      redirect_to "/"
    else
      s= GmaSearch.create :q=>@q, :ip=> request.env["REMOTE_ADDR"]
      do_search
    end
  end
  def err404
    # ma_log 'ERROR', 'main/err404'
    flash[:notice] = "We're sorry, but something went wrong. We've been notified about this issue and we'll take a look at it shortly."
    ma_log "We're sorry, but something went wrong. We've been notified about this issue and we'll take a look at it shortly."
    redirect_to '/'
  end
  def err500
    # ma_log 'ERROR', 'main/err500'
    flash[:notice] = "We're sorry, but something went wrong. We've been notified about this issue and we'll take a look at it shortly."
    ma_log "We're sorry, but something went wrong. We've been notified about this issue and we'll take a look at it shortly."
    redirect_to '/'
  end
end

