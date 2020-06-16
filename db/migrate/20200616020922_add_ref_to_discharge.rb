class AddRefToDischarge < ActiveRecord::Migration[6.0]
  def change
    add_reference :discharges, :load, null: false, foreign_key: true
    add_reference :discharges, :station, null: false, foreign_key: true
  end
end
