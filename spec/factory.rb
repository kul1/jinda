  class Jinda::Module
    include Mongoid::Document
    field :uid, :type => String
    field :code, :type => String
    field :name, :type => String
    field :role, :type => String
    field :seq, :type => String
    field :icon, :type => String
  end
