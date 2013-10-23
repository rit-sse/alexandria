# Checkouts controller
class CheckoutsController < ApplicationController
  before_action :set_checkout, only: [:show, :edit, :update, :destroy]

  # GET /checkouts
  # GET /checkouts.json
  def index
    @checkouts = Checkout.all_active
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
    @checkout = Checkout.new()
    User.all.each do |user|
      @checkout.distributor = user if user.barcode == params['distributor_barcode']
      @checkout.patron = user if user.barcode == params['patron_barcode']
      break unless @checkout.patron.nil? or @checkout.distributor.nil?
    end
    @checkout.book = Book.find_by_isbn(params['isbn']) unless params['isbn'].nil?
    respond_to do |format|
      if @checkout.save
        check_reservation
        format.html { redirect_to request.referer, notice: 'Checkout was successfully created.' }
        format.json { render 'show', status: :created, location: @checkout }
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
