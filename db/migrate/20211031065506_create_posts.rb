require 'time'

class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :location, null: false
      t.string :startTime, default: Time.now.strftime("%m/%d/%Y %H:%M")
      t.string :endTime, default: Time.now.strftime("%m/%d/%Y %H:%M")
      t.text :taskDetails, default: "More about the request", null: true, optional: true
      t.float :credit, null: false
      t.string :email, null: false
      t.integer :postID, null: false
      t.boolean :helperStatus, default: false
      t.string :helperEmail, null: true
      t.boolean :helperComplete, default: false
      t.boolean :requesterComplete, default: false
      t.timestamps
    end
  end
end
