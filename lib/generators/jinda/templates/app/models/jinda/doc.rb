# -*- encoding : utf-8 -*-
class Jinda::Doc
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  field :name, :type => String
  field :filename, :type => String
  field :content_type, :type => String
  field :data_text, :type => String
  field :url, :type => String
  field :basename, :type => String
  field :cloudinary, :type => Boolean
  belongs_to :xmain, :class_name => "Jinda::Xmain"
  belongs_to :runseq, :class_name => "Jinda::Runseq"
  belongs_to :user
  belongs_to :service, :class_name => "Jinda::Service"
  field :ip, :type => String
  field :description, :type => String
  field :category, :type => String
  field :ma_display, :type => Boolean
  field :ma_secured, :type => Boolean
  field :dscan, :type => String
  field :keywords, :type => String

  def self.search(q, page, per_page=PER_PAGE)
    paginate :per_page=>per_page, :page => page, :conditions =>
      ["content_type=? AND data_text LIKE ? AND (ma_secured=? OR ma_user_id=?)",
      "output", "%#{q}%", false, session[:user_id] ],
      :order=>'ma_xmain_id DESC', :select=>'DISTINCT ma_xmain_id'
  end
  def self.search_ma_secured(q, page, per_page=PER_PAGE)
    paginate :per_page=>per_page, :page => page, :conditions =>
      ["content_type=? AND data_text LIKE ?", "output", "%#{q}%" ],
      :order=>'ma_xmain_id DESC', :select=>'DISTINCT ma_xmain_id'
  end
end
