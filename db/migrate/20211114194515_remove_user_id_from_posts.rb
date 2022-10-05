class RemoveUserIdFromPosts < ActiveRecord::Migration[6.0]
  def change
    if ActiveRecord::Base.connection.column_exists?(:posts, :postID)
      remove_column :posts, :postID, :int
    end
    if ActiveRecord::Base.connection.column_exists?(:posts, :user_id)
      remove_column :posts, :user_id, :int
    end
    if ActiveRecord::Base.connection.column_exists?(:posts, :aasm_state)
      remove_column :posts, :aasm_state, :string
    end
    if ActiveRecord::Base.connection.column_exists?(:posts, :accept_user_id)
      remove_column :posts, :accept_user_id, :int
    end
  end
end
