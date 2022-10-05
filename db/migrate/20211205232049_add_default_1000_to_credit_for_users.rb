class AddDefault1000ToCreditForUsers < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :credit, from: 0, to: 1000
  end
end
