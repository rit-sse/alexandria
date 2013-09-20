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
    @checkout = Checkout.new(checkout_params)
    if params[:checkout][:book]
      @checkout.book = Book.find(params[:checkout][:book].to_i)
    end

    respond_to do |format|
      if @checkout.save
        reservation = Reservation.get_reservation(@checkout.book, @checkout.patron)
        if reservation
          reservation.fuffiled = true
          reservation.save
        end

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
    @checkout.checked_in_at = DateTime.now if params[:checkout][:checked_in_at] && params[:checkout][:checked_in_at] == "now"
    respond_to do |format|
      if @checkout.update(checkout_params)
        format.html { redirect_to request.referer, notice: 'Checkout was successfully updated.' }
        format.json { head :no_content }
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
    params.require(:checkout).permit( :checked_out_at, :patron_id)
  end
end
