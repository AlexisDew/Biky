class CreateBikeEquipments < ActiveRecord::Migration[5.2]
  def change
    create_table :bike_equipments do |t|
      t.references :bike, foreign_key: true
      t.references :equipment, foreign_key: {to_table: :equipments}

      t.timestamps
    end
  end
end
