require 'net/smtp'
require 'net/http'
require 'rubygems'
require 'mailfactory'

class UsersController < ApplicationController

  before_action :authorize, only: [:show, :edit, :update]


  def authorize
    @user = User.find_by(id: params[:id])
    if @user.blank? || session[:user_id] != @user.id
      redirect_to root_url, notice: "You are not authorized to do so :D"
    end
  end


  ###

  def new
    @user = User.new
  end


  def create
    user_hash = params.permit(:username, :email, :password)
    @user = User.new(user_hash)
    if @user.save
      redirect_to root_url, notice: "Thanks For Signing Up!"
    else
      render "new"
    end
  end


  ###

  def edit
    #
  end


  def update
    if @user.authenticate(params[:old_password])
      if params[:new_password] == params[:confirm_password]
        @user.password = params[:new_password]
        if @user.save
          redirect_to user_url, notice: 'Your password have been updated.'
          return
        else
          render 'edit'
          return
        end
      end
    else
      redirect_to "/users/change_password/#{@user.id}", notice: 'Wrong passowrd, please try again.'
    end
  end


  def reset_password
    #
  end


  # Reference: http://mailfactory.rubyforge.org
  # gem "mailfactory" used

  def send_password
    user = User.find_by(email: params[:email])
    if !user.present?
      redirect_to users_reset_password_url, notice: "Email address not registered."
      return
    end

    raw_char = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890!@$&' 
    length = 12 
    user.password = Array.new(length){raw_char[rand(raw_char.length)].chr}.join
    if !user.save
      redirect_to reset_password_url, notice: "Generate password error."
      return
    end

    mail = MailFactory.new
    mail.from = 'noreply@goodreading.com'
    mail.to = params[:email]
    mail.subject = 'GoodReading New Password'
    mail.text = "Dear #{user.username}:\n\nPlease use #{user.password} as your new password.\n\nThanks & regards,\nGoodReading.com"
    host = 'smtp.mandrillapp.com'
    port = 587
    key = 'h2UZo7w6dPJrNpVsnFzooA'
    sender = 'lyc@uchicago.edu'
    Net::SMTP.start(host, port, 'mandrillapp.com', sender, key) do |smtp|
      smtp.send_message(mail.to_s, sender, mail.to)
    end

    redirect_to root_url, notice: "A new password has been sent to #{user.email}."
    
  end

end