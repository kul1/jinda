# encoding: utf-8
class Person
  include Mongoid::Document
  # jinda begin
  include Mongoid::Timestamps
  field :fname, :type => String
  field :lname, :type => String
  field :sex, :type => Integer
  belongs_to :address
  field :dob, :type => Date
  field :phone, :type => String
  field :photo, :type => String
  # jinda end
end
