class AddBookingsCountToBikes < ActiveRecord::Migration[5.2]
  def change
    add_column :bikes, :bookings_count, :integer, default: 0, null: false
  end
end
