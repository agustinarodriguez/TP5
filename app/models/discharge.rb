class Discharge < ApplicationRecord
	belongs_to :load
	belongs_to :station

	validates :liters, :date, presence: :true
	validates :liters, numericality: :true
	validate :loaded_truck
	#Voy a validar si el camión tiene lgo para 
	#pfrecerme, si el caḿión está cargado.
	validate :station_liters
	#Queremos validar que los litros que queremos
	#descargar no excedan de los litros permitidos

	def loaded_truck
		#Sacamos liters_load de truck.rb
		if load.truck.liters_load < liters
			self.errors[:truck_id] << "El camión seleccionado no tiene la cantidad de litros que se quieren descargar"
		end
		#Si los litros cargados son menores a los
		#litros que quiero descargar
		#El truck.liters_load no va a tomar porque
		#dice que no está definido truck dentro, pero
		#nosotros ya sabemos que esta relacionado con
		#la carga, entonces ponemos un load. delante.
		true
	end

	def station_liters
		if station.remaining_liters < liters
			self.errors[:station_id] << "La estación de servicio no tine esa capacidad."
		end
	end

	def total_amount
		liters * load.liter_amount
	end
end
