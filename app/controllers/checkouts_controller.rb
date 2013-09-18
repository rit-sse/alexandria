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
  # GET /checkouts/new.json
  def new
    @checkout = Checkout.new
  end

  # GET /checkouts/1/edit
  def edit
  end

  # POST /checkouts
  # POST /checkouts.json
  def create
    if params[:checkout][:book]
      params[:checkout][:book] = Book.find(params[:checkout][:book].to_i)
    end
    @checkout = Checkout.new(checkout_params)

    respond_to do |format|
      if @checkout.save
        reservation = Reservation.get_reservation(@checkout.book, @checkout.patron)
        if reservation
          reservation.fuffiled = true
          reservation.save
        end

        format.html { redirect_to request.referer, notice: 'Checkout was successfully created.' }
        format.json { render json: @checkout, status: :created, location: @checkout }
      else
        format.html { render action: "new" }
        format.json { render json: @checkout.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /checkouts/1
  # PUT /checkouts/1.json
  def update
    if params[:checkout][:checked_in_at] and params[:checkout][:checked_in_at] == "now"
      params[:checkout][:checked_in_at] = DateTime.now
    end

    respond_to do |format|
      if @checkout.update_attributes(checkout_params)
        format.html { redirect_to request.referer, notice: 'Checkout was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
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
      @author = Checkout.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def checkout_params
      params.require(:checkout).permit(:checked_in_at, :checked_out_at, :book, :patron_id)
    end
end
