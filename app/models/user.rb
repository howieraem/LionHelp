class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  authenticates_with_sorcery!
  validates_format_of :email, message: "wrong format, please use your LionMail.",
                      # with: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/
                      with: /\w+([-+.']\w+)*@columbia.edu*/

  validates :email, uniqueness: true
  validates_presence_of :password, message: "should not be empty."
  validates :firstName, presence: true
  validates :lastName, presence: true
end
