# encoding: utf-8
class Comment
  include Mongoid::Document
  # jinda begin
  include Mongoid::Timestamps
  field :body, :type => String
  belongs_to :article
  belongs_to :user, :class_name => "User"
  validates :body, :user_id, :article_id, presence: true
  # jinda end
end
