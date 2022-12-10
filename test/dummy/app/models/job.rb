# encoding: utf-8
class Job
  include Mongoid::Document
  # jinda begin
  include Mongoid::Timestamps
  field :position, :type => String
  field :description, :type => String
  field :company, :type => String
  field :company_address, :type => String
  field :status, :type => String
  field :end_client, :type => String
  field :job_location, :type => String
  field :job_duration, :type => String
  field :issue_on, :type => DateTime
  field :process_at, :type => DateTime
  field :dscan, :type => String
  field :keywords, :type => String
  has_many :comments, as: :commentable
  belongs_to :user, :class_name => "User"
  # jinda end
  include Mongoid::Timestamps
end
