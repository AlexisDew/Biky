class CreateModels < ActiveRecord::Migration[5.2]
  def change
    create_table :models do |t|
      t.string :name
      t.integer :year
      t.integer :engine_size
      t.integer :power
      t.references :brand, foreign_key: true

      t.timestamps
    end
  end
end
