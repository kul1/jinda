

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
