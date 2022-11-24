# encoding: utf-8
class Article
  include Mongoid::Document
  # jinda begin
  include Mongoid::Timestamps
  field :title, :type => String
  field :text, :type => String
  belongs_to :user, :class_name => "User"
  has_many :comments
  validates :title, :text, :user_id, presence: true
  field :body, :type => String
  field :keywords, :type => String
  # jinda end
end
