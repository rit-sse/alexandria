# Checkouts controller
class CheckoutsController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :json_request?
  load_and_authorize_resource
  skip_load_resource only: [:create]
  before_action :set_checkout, only: [:show, :edit, :update, :destroy]
  has_scope :active, type: :boolean
  has_scope :patron
  has_scope :book
  has_scope :overdue, type: :boolean

  # GET /checkouts
  # GET /checkouts.json
  def index
    scope = apply_scopes(Checkout)
    @checkouts = scope.respond_to?(:to_a) ? scope.to_a : scope.all
    @checkouts = @checkouts.paginate(page: params['page'])
  end

  # GET /checkouts/1
  # GET /checkouts/1.json
  def show
  end

  # GET /checkouts/new
  def new
    @checkout = Checkout.new
  end

  # GET /checkouts/1/edit
  def edit
  end

  # POST /checkouts
  # POST /checkouts.json
  def create
    @checkout = Checkout.new
    User.all.each do |user|
      @checkout.distributor = user if user.barcode == params['distributor_barcode']
      @checkout.patron = user if user.barcode == params['patron_barcode']
      break unless @checkout.patron.nil? or @checkout.distributor.nil?
    end
    @checkout.book = Book.find_by_isbn(params['isbn']) unless params['isbn'].nil?
    respond_to do |format|
      if @checkout.save
        check_reservation
        # CheckoutMailer.checkout_book(@checkout).deliver
        format.html { redirect_to @checkout, notice: 'Checkout was successfully created.' }
        format.json { render json: { title: @checkout.book.title }, status: :created, location: @checkout.book }
      else
        format.html { render 'new' }
        format.json { render json: @checkout.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /checkouts/1
  # PATCH/PUT /checkouts/1.json
  def update
    @checkout.checked_in_at = DateTime.now if params[:checkout][:checked_in_at] && params[:checkout][:checked_in_at] == 'now'
    respond_to do |format|
      if @checkout.update(checkout_params)
        if params[:checkout][:checked_in_at] == 'now'
          format.html { redirect_to put_away_book_url(@checkout.book), notice: 'Book was succesfully checked in.' }
          format.json { head :no_content }
        else
          format.html { redirect_to request.referer, notice: 'Checkout was successfully updated.' }
          format.json { head :no_content }
        end
      else
        format.html { render 'edit' }
        format.json { render json: @checkout.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /checkouts/1
  # DELETE /checkouts/1.json
  def destroy
    @checkout.destroy
    respond_to do |format|
      format.html { redirect_to checkouts_url }
      format.json { head :no_content }
    end
  end

  def check_in
    if request.post?
      patron = nil
      distributor_check_in = nil
      User.all.each do |user|
        distributor_check_in = user if user.barcode == params['distributor_barcode']
        patron = user if user.barcode == params['patron_barcode']
        break unless distributor_check_in.nil? or patron.nil?
      end
      @checkout = Book.find_by_isbn(params['isbn']).active_checkout(patron)
      unless @checkout.nil?
        @checkout.checked_in_at = DateTime.now
        @checkout.distributor_check_in = distributor_check_in
      end
      respond_to do |format|
        if @checkout.try(:distributor_check_in).try(:distributor?) or @checkout.try(:distributor_check_in).try(:librarian?)
          @checkout.save
          left_right = Lccable.where_to_place(@checkout.book)
          hash = {
            book: {
              title: @checkout.book.title,
              lcc: @checkout.book.lcc
            },
            left: {
              title: left_right[:left].try(:title) || '',
              image: left_right[:left].try(:google_book_data).try(:img_small) || '',
              lcc: left_right[:left].try(:lcc) || ''
            },
            right: {
              title: left_right[:right].try(:title) || '',
              image: left_right[:right].try(:google_book_data).try(:img_small) || '',
              lcc: left_right[:right].try(:lcc) || ''
            },
            shelf: {
              number: left_right[:shelf].to_s
            }
          }
          format.html { redirect_to put_away_book_url(@checkout.book), notice: 'Book was succesfully checked in.' }
          format.json { render json: hash, status: :ok, location: @checkout.book }
        else
          format.html { redirect_to check_in_url, alert: 'Book not checked out, invalid distributor, or invalid patron' }
          format.json { render json: @checkout.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_checkout
    @checkout = Checkout.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def checkout_params
    params.require(:checkout).permit(:checked_out_at, :patron_id, :book_id, :distributor_id, :due_date)
  end

  def check_reservation
    reservation = Reservation.get_reservation(@checkout.book, @checkout.patron)
    if reservation
      reservation.fulfilled = true
      reservation.save
    end
  end
end
