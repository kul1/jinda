# encoding: utf-8
class Jinda::Doc
  include Mongoid::Document
  # jinda begin
  include Mongoid::Timestamps
  field :a, :type => String
  field :b, :type => String
  field :c, :type => String
  field :d, :type => String
  field :x, :type => String
  field :y, :type => String
  field :z, :type => String
  field :s, :type => String
  field :t, :type => String
  field :u, :type => String
  field :w, :type => String
  field :yes, :type => Boolean
  field :dscan, :type => String
  field :process_at, :type => Date
  field :issue_on, :type => Date
  # jinda end
end
