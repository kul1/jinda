class Identity
  include Mongoid::Document
  include OmniAuth::Identity::Models::Mongoid

  auth_key "code"

  field :code, :type => String
  field :email, :type => String
  field :password_digest, :type => String
  field :auth_token, :type => String
  field :image, :type => String

  validates :code, presence: true
  validates :code, uniqueness: true
  validates :email, uniqueness: true
  # validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
end
