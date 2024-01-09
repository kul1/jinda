module AuthenticationHelper
  # controller return 1. Session 2. Cookies ==> user.id
  def sign_in(user)
    @user = user
    current_ma_user
  end

  def create_and_sign_in_user
    user = FactoryBot.create(:user)
    sign_in(user)
    return user
  end
	# from Jinda::Helpers
  def  current_ma_user 
       @user ||= User.where(:auth_token => user.auth_token)
       return @user
  end

end

