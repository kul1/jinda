# -*- encoding : utf-8 -*-
class Jinda::Xmain
  include Mongoid::Document
  field :xid, :type => String
  # Jinda begin
  include Mongoid::Timestamps
  belongs_to :service, :class_name => "Jinda::Service"
  field :start, :type => DateTime
  field :stop, :type => DateTime
  field :name, :type => String
  field :ip, :type => String
  field :status, :type => String
  belongs_to :user, :class_name => "User"
  field :xvars, :type => Hash
  field :current_runseq, :type => String
  # Jinda end

  has_many :runseqs, :class_name => "Jinda::Runseq"
  has_many :docs, :class_name => "Jinda::Doc"
  before_create :assign_xid


  # number of xmains on the specified date
  def self.get(xid)
    find_by(xid:xid)
  end
  def assign_xid
    self.xid = Param.gen(:xid)
  end
  def self.number(d)
    all(:conditions=>['DATE(created_at) =?', d.to_date]).count
  end
  def self.search(q, page, per_page=10)
    paginate :per_page=>per_page, :page => page, :conditions =>
      ["LOWER(xvars) LIKE ?", "%#{q}%" ],
      :order=>'created_at DESC'
  end
end
