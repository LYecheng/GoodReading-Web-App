class FavoritesController < ApplicationController

  before_action :require_user, :only => [:show, :edit, :update, :destroy]

  def require_user
    if session[:user_id].blank?
      redirect_to book_url, notice: 'Please log in first.'
    else
      @user = User.find_by(id: session['user_id']
    end
  end



  ###

  def index
    
  end

  def create
    
  end

  def new
    
  end

  def edit
  
  end

  def show
    
  end

  def update
    
  end

  def destroy
    
  end

end