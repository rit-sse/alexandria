# Controller for books
class BooksController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :json_request?
  load_and_authorize_resource
  skip_load_resource only: [:create]
  before_action :set_book, only: [:show, :edit, :update, :destroy, :put_away]
  before_filter :authenticate!
  skip_before_filter :authenticate!, only: [:index, :show, :create]

  # GET /books
  # GET /books.json
  def index
    books_with_isbn = Book.where(isbn: params[:search])
    if books_with_isbn.any? and not request.format.json?
      redirect_to books_with_isbn.first
      return
    else
      search
      @books = @books.first(params[:limit].to_i) if params[:limit]
      @query = params[:search]
      unless request.format.json?
        @books = @books.paginate(page: params['page'])
      end
    end
    respond_to do |format|
      format.html
      format.json { 'show' }
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
    goodreads = Goodreads.new.book_by_isbn(@book.isbn)
    @rating = goodreads.average_rating.to_f
    @num_ratings = goodreads.work.ratings_count
  rescue
    @rating = 0.0
    @ratings_count = 0
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
    librarian = nil
    User.all.each do |user|
      librarian = user if user.barcode == params['librarian_barcode']
      break unless librarian.nil?
    end
    cheese = {}
    if librarian.try(:librarian?)
      @book = Book.add_by_isbn(params[:isbn])
      cheese[:isbn] = ["ISBN is invalid"] if @book.errors.any?
    else
      cheese[:librarian] = ["Librarian pin is invalid."]
    end
    respond_to do |format|
      if @book.present? and @book.errors.empty? and @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render json: { title: @book.title }, status: :created, location: @book }
      else
        format.html { redirect_to root_path, notice: 'Book was not created.'}
        format.json { render json: cheese , status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    @book.authors = params[:book][:authors].delete_if { |x| x == '' }.map { |i| Author.find(i) } if params[:book][:authors].present?
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
    params.require(:book).permit(:isbn, :publish_date, :title, :subtitle,
                                 :restricted, :lcc, :unavailable, google_book_data_attributes:
                                 [:description, :img_thumbnail, :img_small, :img_medium, :img_large, :preview_link])
  end

  def search
    if params[:search]
      @search = Book.search do
        fulltext params[:search]
        paginate page: 1, per_page: Book.count
      end
      @books = @search.results
    else
      @books = Book.all
    end
  end
end
