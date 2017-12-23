# encoding: utf-8
class SessionsController < ApplicationController
  def new
    @title= 'Sign In'
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
    refresh_to root_path, :ma_notice => "Logged in"
  rescue
    redirect_to root_path, :alert=> "Authentication failed, please try again."
  end

  def destroy
    #session[:user_id] = nil
    cookies.delete(:auth_token)
    # redirect_to '/jinda/help'
    refresh_to root_path, :ma_notice => "Logged Out"
    #  render not work!!
    #redirect_to 'jinda/index'
  end

  def failure
    ma_log "Authentication failed, please try again."
    redirect_to root_path, :alert=> "Authentication failed, please try again."
  end
end
