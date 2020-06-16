class DischargesController < ApplicationController
  before_action :set_discharge, only: [:show, :edit, :update, :destroy]

  # GET /discharges
  # GET /discharges.json
  def index
    @discharges = Discharge.all
    @discharges = @discharges.where(:station_id => params[:station_id]) unless params[:station_id].blank?
    t = Truck.find(params[:truck_id]) unless params[:truck_id].blank?
    @discharges = @discharges.where(:load_id => t.loads.map(&:id)) unless t.nil?
    @discharges = @discharges.where("liters < ?", params[:liters]) unless[:liters].blank?
  end

  # GET /discharges/1
  # GET /discharges/1.json
  def show
  end

  # GET /discharges/new
  def new
    @discharge = Discharge.new
    @trucks = Truck.all.select { | t | (t.liters_load) > 0 }
    #Con el select filtramos solamente los camiones que tienen carga mayor a cero.
    #Los que no están cargados (loads) no aparecen en discharges.
    @stations = Station.all.select { | s | (s.max_liters - s.loaded_liters) > 0 }
    #De todas las estaciones elegimos sólo las que tengan capacidad, es decir, mayores a 0.
    #Con el select lo que hacemos es filtrar.
  end

  # GET /discharges/1/edit
  def edit
  end

  # POST /discharges
  # POST /discharges.json
  def create
    @discharge = Discharge.new(discharge_params)
    @trucks = Truck.all.select { | t | (t.liters_load) > 0 }
    @stations = Station.all.select { | s | (s.max_liters - s.loaded_liters) > 0 }

    #Suponemos que el camión solo tiene una carga por vez.
    @discharge.load_id = Truck.find(params[:truck_id]).available_load.id


    respond_to do |format|
      if @discharge.save
        format.html { redirect_to @discharge, notice: 'Discharge was successfully created.' }
        format.json { render :show, status: :created, location: @discharge }
      else
        format.html { render :new }
        format.json { render json: @discharge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /discharges/1
  # PATCH/PUT /discharges/1.json
  def update
    respond_to do |format|
      if @discharge.update(discharge_params)
        format.html { redirect_to @discharge, notice: 'Discharge was successfully updated.' }
        format.json { render :show, status: :ok, location: @discharge }
      else
        format.html { render :edit }
        format.json { render json: @discharge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discharges/1
  # DELETE /discharges/1.json
  def destroy
    @discharge.destroy
    respond_to do |format|
      format.html { redirect_to discharges_url, notice: 'Discharge was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_discharge
      @discharge = Discharge.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def discharge_params
      params.require(:discharge).permit(:liters, :date, :station_id, :load_id)
    end
end
