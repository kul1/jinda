# encoding: utf-8
class Address
  include Mongoid::Document
  # jinda begin
  include Mongoid::Timestamps
  field :address_street, :type => String
  field :city, :type => String
  field :state, :type => String
  field :zip, :type => String
  field :phone, :type => String
  field :lat, :type => Float
  field :lng, :type => Float
  # jinda end
end
