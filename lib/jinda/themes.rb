
    # ############################### Themes ###################################
    #
    # Check login user information from User model: name(code), image for Themes
    #
    # ##########################################################################
    def get_login_user_info
      if current_ma_user.present?
        $user_image = current_ma_user.image
        $user_name = current_ma_user.code
        $user_email = current_ma_user.email
        $user_id = current_ma_user.try(:id)
      else
        $user_image = asset_url("user.png", :width => "48")
        $user_name = 'Guest User'
        $user_email = 'guest@sample.com'
        $user_id = ''
      end
      return $user_image, $user_name, $user_email,$user_id
    end

