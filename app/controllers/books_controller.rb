# Controller for books
class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy, :put_away]
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
    @rating = Goodreads.new.book_by_isbn(@book.isbn).average_rating.to_f
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # GET /books/1/put_away
  def put_away
    left_right = Lccable.where_to_place(@book)
    @left = left_right[:left]
    @right = left_right[:right]
    @shelf = left_right[:shelf]
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
    @book.authors = params[:book][:authors].delete_if { |x| x == '' }.map { |i| Author.find(i) }
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
    params.require(:book).permit(:isbn, :publish_date, :title, :subtitle, :restricted, :lcc)
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
