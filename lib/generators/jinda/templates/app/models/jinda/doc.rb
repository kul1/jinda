# encoding: utf-8
class Jinda::Doc
  include Mongoid::Document
  # jinda begin
  include Mongoid::Timestamps
  field :issue_on, :type => Date
  field :process_at, :type => Date
  field :summary, :type => String
  field :dscan, :type => String
  field :hotel, :type => String
  field :done, :type => Boolean
  field :rnum, :type => String
  field :confidential, :type => String
  # jinda end
end
