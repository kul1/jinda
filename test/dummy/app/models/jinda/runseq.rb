module Jinda
  class Runseq
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :user, :class_name => "User"
    belongs_to :xmain, :class_name => "Jinda::Xmain"

    field :action, :type => String
    field :status, :type => String
    field :code, :type => String
    field :name, :type => String
    field :role, :type => String
    field :rule, :type => String
    field :rstep, :type => Integer
    field :form_step, :type => Integer
    field :start, :type => DateTime
    field :stop, :type => DateTime
    field :end, :type => Boolean
    field :xml, :type => String
    field :ip, :type => String

    scope :form_action, -> { where(:action.in=> %w[form output pdf]) }
  end
end
