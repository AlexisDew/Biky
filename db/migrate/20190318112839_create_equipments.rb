class CreateEquipments < ActiveRecord::Migration[5.2]
  def change
    create_table :equipments do |t|
      t.string :name
      t.string :logo_url

      t.timestamps
    end
  end
end
