# -*- encoding : utf-8 -*-
class Jinda::Notice
  include Mongoid::Document
  include Mongoid::Timestamps
  field :message, :type => String
  field :unread, :type => Boolean
  field :ip, :type => String
  belongs_to :user, :class_name => "User"

  def self.recent(user_id, ip)
    where(unread: true, ip: ip).last
    # where(unread: true, user_id: user_id, ip: ip).last
  end
end
