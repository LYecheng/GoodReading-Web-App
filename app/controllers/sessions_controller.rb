class SessionsController < ApplicationController
  
  def new
    @user = User.new
    if session[:user_id].present?
      redirect_to root_url
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user
      if user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to root_url, notice: 'Welcome Back!'
      else
        redirect_to root_url, notice: 'Password Incorrect.'
      end
    else
      redirect_to root_url, notice: 'Unknown Email.'
    end
  end

  def destroy
    if session[:user_id].present?
      session.delete(:user_id)
      redirect_to root_url, notice: 'Logout Successful.'
    else
      redirect_to root_url, notice: 'Logout Error.'
    end
  end
  
end