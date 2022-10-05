class Comment < ApplicationRecord
    validates :commenter, :content, :postID, presence: true
end
