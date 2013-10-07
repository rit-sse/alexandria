# Controller for books
class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate!
  skip_before_filter :authenticate!, only: [:index, :show, :create]

  # GET /books
  # GET /books.json
  def index
    books_with_isbn = Book.where(isbn: params[:search])
    if books_with_isbn.any?
      redirect_to books_with_isbn.first
    else
      search
      @books = @books.first(params[:limit].to_i) if params[:limit]
      @query = params[:search]
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.add_by_isbn(params[:isbn])

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render 'show', status: :created, location: @book }
      else
        format.html { render 'new' }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render 'edit' }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def book_params
    params.require(:book).permit(:isbn, :publish_date, :title, :subtitle)
  end

  def search
    if params[:search]
      @search = Book.search do
        fulltext params[:search]
      end
      @books = @search.results
    else
      @books = Book.all
    end
  end
end
