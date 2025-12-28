# frozen_string_literal: true

module ActionView
  module Helpers
    module DateHelper
      def date_field_tag(method, options = {})
        default = options[:default] || Time.zone.today
        data_options = { 'mode' => 'calbox' }.merge(options)
        %(<input name='#{method}' id='#{method}' value='#{default.strftime('%F')}' type='date' data-role='datebox' data-options='#{data_options.to_json}'>).html_safe
      end
    end

    class FormBuilder
      def date_select_thai(method)
        date_select method, use_month_names: THAI_MONTHS, order: %i[day month year]
      end

      def date_field(method, options = {})
        default = options[:default] || object.send(method) || Time.zone.today
        data_options = { 'mode' => 'calbox' }.merge(options)
        out = %(<input name='#{object_name}[#{method}]' id='#{object_name}_#{method}' value='#{default.strftime('%F')}' type='date' data-role='datebox' data-options='#{data_options.to_json}'>)
        out.html_safe
      end

      def time_field(method, options = {})
        default = object.send(method) || Time.zone.now
        data_options = { 'mode' => 'timebox' }.merge(options)
        out = %(<input name='#{object_name}[#{method}]' id='#{object_name}_#{method}' value='#{default}' type='date' data-role='datebox' data-options='#{data_options.to_json}'>)
        out.html_safe
      end

      def date_select_thai(method, default = Time.zone.now, disabled = false)
        date_select method, default: default, use_month_names: THAI_MONTHS, order: %i[day month year],
                            disabled: disabled
      end

      def datetime_select_thai(method, default = Time.zone.now, disabled = false)
        datetime_select method, default: default, use_month_names: THAI_MONTHS, order: %i[day month year],
                                disabled: disabled
      end

      def point(o = {})
        o[:zoom] = 11 unless o[:zoom]
        o[:width] = '100%' unless o[:width]
        o[:height] = '300px' unless o[:height]
        o[:lat] = 13.91819 unless o[:lat]
        o[:lng] = 100.48889 unless o[:lng]

        out = <<-EOT
  <script type='text/javascript'>
  //<![CDATA[
    var latLng;
    var map_#{object_name};
    var marker_#{object_name};

    function init_map() {
      var lat =  #{o[:lat]};
      var lng =  #{o[:lng]};
      //var lat =  position.coords.latitude"; // HTML5 pass position in function initialize(position)
      // google.loader.ClientLocation.latitude;
      //var lng =  position.coords.longitude;
      // google.loader.ClientLocation.longitude;
      latLng = new google.maps.LatLng(lat, lng);
      map_#{object_name} = new google.maps.Map(document.getElementById("map_#{object_name}"), {
        zoom: #{o[:zoom]},
        center: latLng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      });
      marker_#{object_name} = new google.maps.Marker({
        position: latLng,
        map: map_#{object_name},
        draggable: true,
      });
      google.maps.event.addListener(marker_#{object_name}, 'dragend', function(event) {
        $('##{object_name}_lat').val(event.latLng.lat());
        $('##{object_name}_lng').val(event.latLng.lng());
      });
      google.maps.event.addListener(map_#{object_name}, 'click', function(event) {
        $('##{object_name}_lat').val(event.latLng.lat());
        $('##{object_name}_lng').val(event.latLng.lng());
        move();
      });
      $('##{object_name}_lat').val(lat);
      $('##{object_name}_lng').val(lng);
    };

    function move() {
      latLng = new google.maps.LatLng($('##{object_name}_lat').val(), $('##{object_name}_lng').val());
      map_#{object_name}.panTo(latLng);
      marker_#{object_name}.setPosition(latLng);
    }

    //google.maps.event.addDomListener(window, 'load', init_map);

  //]]>
  </script>
  <div class="field" data-role="fieldcontain">
    Latitude: #{text_field :lat, style: 'width:300px;'}
    Longitude: #{text_field :lng, style: 'width:300px;'}
  </div>
  <p/>
  <div id='map_#{object_name}' style='max-width: none !important; width:#{o[:width]}; height:#{o[:height]};' class='map'></div>
  <script>
    $('##{object_name}_lat').change(function() {move()});
    $('##{object_name}_lng').change(function() {move()});
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
