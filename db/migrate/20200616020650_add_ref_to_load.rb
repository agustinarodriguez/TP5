class AddRefToLoad < ActiveRecord::Migration[6.0]
  def change
    add_reference :loads, :truck, null: false, foreign_key: true
  end
end
