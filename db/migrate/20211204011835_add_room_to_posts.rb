class AddRoomToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :room, :string, after: :location
  end
end
