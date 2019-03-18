class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.string :text
      t.references :author, foreign_key: {to_table: :users}
      t.references :destinator, foreign_key: {to_table: :users}
      t.date :date

      t.timestamps
    end
  end
end
