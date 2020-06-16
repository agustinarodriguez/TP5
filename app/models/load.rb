class Load < ApplicationRecord
	belongs_to :truck
	has_many :discharges

	validates :liters, :date, :liter_amount, presence: :true
	validates :liters, :liter_amount, numericality: :true

	#Para hacer el punto 2 que dice que se debe
	#validar que no se puedan cargar más litros
	#si ya se alcanzó el máximo, y que cada vez
	#que se quiera cargar el camión que compare
	#cuánto está cargado para no cargar más.
	validate :full_truck
	validate :full_liters

	def full_truck
		if truck.remaining_liters < liters
			self.errors[:truck_id] << "El camión seleccionado no tiene capacidad para esa cantidad de litros"
		end
	end

	def full_liters
		if truck.max_liters < liters
			self.errors[:truck_id] << "Los litros superan la capacidad máxima del camión"
		end
	end

	def discharges_liters
		l = 0
		discharges.each do | dis |
			l += l + dis.liters
		end
		l
		#Para que me devuelva los litros restantes.
	end
end
