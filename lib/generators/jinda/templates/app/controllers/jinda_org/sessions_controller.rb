# encoding: utf-8
class SessionsController < ApplicationController
  def new
    @title= 'Sign In'
  end

  def failure
    redirect_to login_path, alert: "Authentication failed, please try again."
  end

  # to refresh the page, must know BEFOREHAND that the action needs refresh
  # then use attribute 'data-ajax'=>'false'
  # see app/views/sessions/new.html.erb for sample
  def create
    auth = request.env["omniauth.auth"]
    user = User.from_omniauth(auth)
    session[:user_id] = user.id
    if params.permit[:remember_me]
      cookies.permanent[:auth_token] = user.auth_token
    else
      cookies[:auth_token] = user.auth_token
    end
    # refresh_to root_path, :ma_notice => "Logged in" # Called by jinda_conroller
    # redirect_to root_path
		redirect_to articles_my_path

  rescue
    redirect_to root_path, :alert=> "Authentication failed, please try again."
  end

  def destroy
    session[:user_id] = nil
    cookies.delete(:auth_token)
    refresh_to root_path, :ma_notice => "Logged Out" # called by jinda_controller, not pass tested
    # redirect_to root_path # Ok with test

  end

  def failure
    ma_log "Authentication failed, please try again."
    redirect_to root_path, :alert=> "Authentication failed, please try again."
  end
end
