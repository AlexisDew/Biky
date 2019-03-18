class CreateBikes < ActiveRecord::Migration[5.2]
  def change
    create_table :bikes do |t|
      t.string :color
      t.references :model, foreign_key: true
      t.references :owner, foreign_key: {to_table: :users}
      t.references :city, foreign_key: true

      t.timestamps
    end
  end
end
