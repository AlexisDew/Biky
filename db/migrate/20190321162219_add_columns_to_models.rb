class AddColumnsToModels < ActiveRecord::Migration[5.2]
  def change
    add_column :models, :category, :string
    add_column :models, :tank_capacity, :string
    add_column :models, :saddle_height, :string
    add_column :models, :length, :string
    add_column :models, :width, :string
    add_column :models, :height, :string
    add_column :models, :weight, :string
    add_column :models, :full_weight, :string
    add_column :models, :power_ratio, :string
    add_column :models, :max_speed, :string
    add_column :models, :acceleration, :string
    add_column :models, :consumption, :string
    add_column :models, :motor_type, :string
    add_column :models, :a2_compatibility, :string
  end
end
