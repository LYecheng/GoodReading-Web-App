class BooksController < ApplicationController

  before_action :require_user, :only => [:create, :new, :edit, :update, :destroy, :add_favorite]
  before_action :find_book, :only => [:show, :edit, :update, :destroy]

  def require_user
    if session[:user_id].blank?
      redirect_to root_url, notice: "Please log in."
    end
  end


  def find_book
    @book = Book.find_by(id: params["id"])
  end


  ###
  
  def index
    if params[:keyword].present?
      @books = Book.where("name LIKE ?", "%#{params[:keyword]}%")
    else
      @books = Book.all
    end
    @books = @books.order('name asc').page(params[:page]).per(7)
  end


  def create
    @new_book = Book.new
    @new_book.isbn = params[:isbn]
    @new_book.name = params[:name]
    @new_book.year = params[:year]
    @new_book.rating = params[:rating]
    @new_book.image = params[:image]
    @new_book.description = params[:description]
    @new_book.author_id = params[:author_id]
    @new_book.category_id = params[:category_id]
    @new_book.save
    redirect_to books_url, notice: "Book #{@new_book.name} added."
  end


  def new
    @new_book = Book.new
    @authors = Author.all.order('name asc')
    @category = Category.all.order('name asc')
    render "new"
  end


  def show
    if @book == nil
      redirect_to books_url, notice: "Book not found."
      return
    else
      cookies['book_ids'] ||= ""
      if !cookies['book_ids'].include?(@book.id.to_s)
        cookies['book_ids'] += "#{@book.id}"
      end
    end
  end


  def edit
    @category_id = @book.category_id
    @author_id = @book.author_id
    @authors = Author.all.order('name asc')
    @category = Category.all.order('name asc')
    render "edit"
  end


  def update
    @book.isbn = params[:isbn]
    @book.name = params[:name]
    @book.year = params[:year]
    @book.rating = params[:rating]
    @book.category_id = params[:category_id]
    @book.image = params[:image]
    @book.author_id = params[:author_id]
    @book.description = params[:description]
    if @book.save
      redirect_to books_url, notice: "Update Successful!"
      return
    else
      @authors = Author.order('name')
      render "edit"
      return
    end
  end


  def destroy
    @book.delete
    redirect_to books_url
  end 


  def add_favorite
    if Favorite.find_by(book_id: params[:id]).present?
      redirect_to "/books/#{params[:id]}", notice: "Already in Favorite."
      return
    else
      favorite = Favorite.new
      favorite.book_id = params[:id]
      favorite.user_id = session[:user_id]
      favorite.save
      redirect_to "/books/#{params[:id]}", notice: "Added to Favorite. Go to 'Home' to check your favorite books."
      return
    end
  end


  def remove_favorite
    if Favorite.find_by(book_id: params[:id]).present?
      Favorite.find_by(book_id: params[:id]).delete
      redirect_to "/books/#{params[:id]}", notice: "Removed from Favorite. Go to 'Home' to check your favorite books."
      return
    else
      redirect_to "/books/#{params[:id]}", notice: "Already Removed from Favorite."
      return
    end
  end

end
