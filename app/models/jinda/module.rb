# -*- encoding : utf-8 -*-
class Jinda::Module
  include Mongoid::Document
  field :uid, :type => String
  field :code, :type => String
  field :name, :type => String
  field :role, :type => String
  field :seq, :type => Integer
  field :icon, :type => String
  has_many :services, :class_name => "Jinda::Service"
end
