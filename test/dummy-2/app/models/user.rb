class User
  include Mongoid::Document
	# https://docs.mongodb.com/mongoid/master/tutorials/mongoid-indexes/
  index({ code: 1 }, { unique: true, name: "code_index" })
  before_create {generate_token(:auth_token)}
  field :provider, :type => String
  field :uid, :type => String
  field :code, :type => String
  field :email, :type => String
  field :role, :type => String
  field :user, :type => String
  field :auth_token, :type => String
  field :password_reset_token, :type => String
  field :password_reset_sent_at,:type => DateTime
  field :image, :type => String

  belongs_to :identity, :polymorphic => true, :optional => true
  has_many :xmains, :class_name => "Jinda::Xmain"
  validates :code,
		presence: true,
		uniqueness: true

  ## Add to create forgot password
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end
    #end while User.exists?(column => self[column])
  end

  def has_role(role1)
    return role.upcase.split(',').include?(role1.upcase)
  end
  
  def self.from_omniauth(auth)
  # Rails now no longer support slice 
  # where(auth.slice(:uid, :provider, :email)).first_or_create do |user|
    where(uid: auth.uid, provider: auth.provider, email: auth.info.email).first_or_create do |user|
      case auth.provider 
        when 'identity'
          identity = Identity.find auth.uid
          user.code = identity.code
          user.email = identity.email
        else
          user.email = auth.info.email
          user.uid = auth.uid
          user.provider = auth.provider
          user.code = auth.info.name
          user.role = "M"
          user.image = auth.info.image
        end
      end
    end
         
  def ma_secured?
    role.upcase.split(',').include?(ma_secured_ROLE)
  end
  
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

end
