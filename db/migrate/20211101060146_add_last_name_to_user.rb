class AddLastNameToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :lastName, :string
  end
end
