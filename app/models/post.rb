class Post < ApplicationRecord
  belongs_to :user, optional: true
  validates :title, presence: true
  validates :location, presence: true
  validates :startTime, presence: true
  validates :endTime, presence: true
  validates :taskDetails, presence: true
  validates :credit, presence: true
  validates :email, presence: true
  # validates :helperStatus, presence: true
  # validates :helperEmail, presence: true
  # validates :helperComplete, presence: true
  # validates :requesterComplete, presence: true
end
