class StrikesController < ApplicationController
  # GET /strikes
  # GET /strikes.json
  def index
    @strikes = Strike.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @strikes }
    end
  end

  # GET /strikes/1
  # GET /strikes/1.json
  def show
    @strike = Strike.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @strike }
    end
  end

  # GET /strikes/new
  # GET /strikes/new.json
  def new
    @strike = Strike.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @strike }
    end
  end

  # GET /strikes/1/edit
  def edit
    @strike = Strike.find(params[:id])
  end

  # POST /strikes
  # POST /strikes.json
  def create
    @strike = Strike.new(params[:strike])

    respond_to do |format|
      if @strike.save
        format.html { redirect_to @strike, notice: 'Strike was successfully created.' }
        format.json { render json: @strike, status: :created, location: @strike }
      else
        format.html { render action: "new" }
        format.json { render json: @strike.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /strikes/1
  # PUT /strikes/1.json
  def update
    @strike = Strike.find(params[:id])

    respond_to do |format|
      if @strike.update_attributes(params[:strike])
        format.html { redirect_to @strike, notice: 'Strike was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @strike.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /strikes/1
  # DELETE /strikes/1.json
  def destroy
    @strike = Strike.find(params[:id])
    @strike.destroy

    respond_to do |format|
      format.html { redirect_to strikes_url }
      format.json { head :no_content }
    end
  end
end
