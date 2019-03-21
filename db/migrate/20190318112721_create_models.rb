class CreateModels < ActiveRecord::Migration[5.2]
  def change
    create_table :models do |t|
      t.string :name
      t.integer :year, :integer
      t.integer :engine_size, :integer
      t.integer :power, :integer
      t.references :brand, foreign_key: true

      t.timestamps
    end
  end
end
