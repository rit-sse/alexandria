# Strikes controller
class StrikesController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: [:create]
  before_action :set_strike, only: [:show, :edit, :update, :destroy]

  # GET /strikes
  # GET /strikes.json
  def index
    @strikes = Strike.all
  end

  # GET /strikes/1
  # GET /strikes/1.json
  def show
  end

  # GET /strikes/new
  def new
    @strike = Strike.new
  end

  # GET /strikes/1/edit
  def edit
  end

  # POST /strikes
  # POST /strikes.json
  def create
    @strike = Strike.new(strike_params)
    User.all.each do |user|
      @strike.distributor = user if user.barcode == params['distributor_barcode']
      break unless @strike.distributor.nil?
    end
    respond_to do |format|
      if @strike.save
        StrikeMailer.strike(@strike).deliver
        if @strike.patron.strikes.count == Rails.configuration.strikes_for_ban
          StrikeMailer.banned(@strike.patron).deliver
          patron = @strike.patron
          patron.banned = true
          patron.save
        end
        format.html { redirect_to @strike, notice: 'Strike was successfully created.' }
        format.json { render 'show', status: :created, location: @strike }
      else
        format.html { render 'new' }
        format.json { render json: @strike.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /strikes/1
  # PATCH/PUT /strikes/1.json
  def update
    respond_to do |format|
      if @strike.update(strike_params)
        format.html { redirect_to @strike, notice: 'Strike was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render 'edit' }
        format.json { render json: @strike.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /strikes/1
  # DELETE /strikes/1.json
  def destroy
    @strike.destroy
    respond_to do |format|
      format.html { redirect_to strikes_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_strike
    @strike = Strike.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def strike_params
    params.require(:strike).permit(:other_info, :reason_id, :patron_id)
  end
end
