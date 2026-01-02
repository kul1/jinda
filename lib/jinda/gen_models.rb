# frozen_string_literal: true

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

  models = @app.elements["//node[@TEXT='models']"] || REXML::Document.new
  models.each_element('node') do |model|
    # t << "= "+model.attributes["TEXT"]
    model_name = model.attributes['TEXT']
    next if model_name.comment?

    model_code = name2code(model_name)
    model_file = Rails.root.join("app/models/#{model_code}.rb").to_s

    system("rails generate model #{model_code}") unless File.exist?(model_file)
    doc = File.read(model_file)

    doc       = add_utf8(doc)
    attr_hash = make_fields(model)
    doc       = add_jinda(doc, attr_hash)
    # t << "modified:   #{model_file}"
    File.open(model_file, 'w') do |f|
      f.puts doc
    end
  end

  # puts t.join("\n")
end

def add_jinda(doc, attr_hash)
  if /#{@btext}/.match?(doc)
    s1, _, s3 = doc.partition(/  #{@btext}.*#{@etext}\n/m)
    s2        = ''
  else
    s1, s2, s3 = doc.partition("include Mongoid::Document\n")
  end
  doc = s1 + s2 + <<-EOT
  #{@btext}
  include Mongoid::Timestamps
  EOT

  attr_hash.each do |a|
    # doc+= "\n*****"+a.to_s+"\n"
    if a[:edit]
      doc += "  #{a[:text]}\n"
    else
      # Fixed: Capitalize only first char
      # doc += "  field :#{a[:code]}, :type => #{a[:type].capitalize}\n"
      a[:type][0] = a[:type][0].capitalize
      doc        += "  field :#{a[:code]}, :type => #{a[:type]}\n"
    end
  end
  doc += "  #{@etext}\n"
  doc + s3
end

def add_utf8(doc)
  if /encoding\s*:\s*utf-8/.match?(doc)
    doc
  else
    doc.insert 0, "# encoding: utf-8\n"
  end
end

# inspect all nodes that has attached file (2 cases) and replace relative path with absolute path
def make_folders_absolute(f, tt)
  tt.elements.each('//node') do |nn|
    nn.attributes['LINK'] = File.expand_path(File.dirname(f)) + "/#{nn.attributes['LINK']}" if nn.attributes['LINK']
  end
end

def name2code(s)
  # rather not ignore # symbol cause it could be comment
  code, = s.split(':')
  code.downcase.strip.tr(' ', '_').gsub(%r{[^#_/a-zA-Z0-9]}, '')
end

def model_exists?(model)
  File.exist? Rails.root.join("app/models/#{model}.rb").to_s
end

def make_fields(n)
  # s= field string used by generate model cli (old style jinda)
  s = ''
  # h= hash :code, :type, :edit, :text
  h = []
  n.each_element('node') do |nn|
    text = nn.attributes['TEXT']
    icon = nn.elements['icon']
    edit = icon && icon.attribute('BUILTIN').value == 'edit'
    next if text.comment? && !edit

    # sometimes freemind puts all fields inside a blank node
    if text.empty?
      nn.each_element('node') do |nnn|
        icon  = nnn.elements['icon']
        edit1 = icon && icon.attribute('BUILTIN').value == 'edit'
        text1 = nnn.attributes['TEXT']
        next if /\#.*/.match?(text1)

        k, v = text1.split(/:\s*/, 2)
        v  ||= 'string'
        v    = 'float' if /double/i.match?(v)
        s << " #{name2code(k.strip)}:#{v.strip} "
        h << { code: name2code(k.strip), type: v.strip, edit: edit1, text: text1 }
      end
    else
      k, v = text.split(/:\s*/, 2)
      v  ||= 'string'
      v    = 'float' if /double/i.match?(v)
      s << " #{name2code(k.strip)}:#{v.strip} "
      h << { code: name2code(k.strip), type: v.strip, edit: edit, text: text }
    end
  end
  # f
  h
end

########################################################################
#                     END  code from jinda.rake                        #
########################################################################
