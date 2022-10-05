class AddCreditToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :credit, :int, :default => 0
  end
end
