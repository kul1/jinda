# encoding: utf-8
class Picture
  include Mongoid::Document
  # jinda begin
  include Mongoid::Timestamps
  field :picture, :type => String
  field :description, :type => String
  belongs_to :user
  # jinda end
  include Mongoid::Timestamps
end
