class AuthorsController < ApplicationController

  before_action :require_user, :only => [:create, :new, :edit, :update, :destroy, :add_favorite]
  before_action :find_author, :only => [:show, :edit, :update, :destroy]
  
  def require_user
    if session[:user_id].blank?
      redirect_to authors_url, notice: "Please log in."
    end
  end

  
  def find_author
    @author = Author.find_by(id: params["id"])
  end



  ###
  
  def index
    @authors = Author.order('name asc').page(params[:page]).per(7)
  end


  def create
    author_hash = params.require(:author).permit(:name)
    @author = Author.new(author_hash)
    if @author.save
      redirect_to authors_url, notice: "Author #{@author.name} added."
      return
    else
      render "new"
      return
    end
  end


  def new
    @author = Author.new
    
  end


  def edit
    
  end


  def show
    if @author == nil
      redirect_to authors_url, notice: "Author does not exist."
    end
  end


  def update
    @author.name = params[:name]
    if @author.save
      redirect_to authors_url, notice: "Update Author #{@author.name} Successful!"
      return
    else
      render "edit"
      return
    end
  end


  def destroy
    @author.delete
    redirect_to author_url
  end
  
end