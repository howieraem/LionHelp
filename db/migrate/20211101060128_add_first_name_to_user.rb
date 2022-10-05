class AddFirstNameToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :firstName, :string
  end
end
