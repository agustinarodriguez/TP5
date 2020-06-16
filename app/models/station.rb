class Station < ApplicationRecord
	has_many :discharges

	validates :adress, :flag, :max_liters, presence: :true
	validates :max_liters, numericality: :true

	def loaded_liters
		liters = 0
		discharges.each do | d |
			liters += d.liters
		end
		liters
	end

	def remaining_liters
		max_liters - loaded_liters
		#Capacidad máxima de litros de la estación
		#menos los litros ya cargados para saber los
		#litrso restantes que faltarían para que la 
		#estación esté llena.
	end

	def total_discharges_amount
		total = 0
		discharges.each do | d |
			total += d.total_amount
		end
		total
	end
end
