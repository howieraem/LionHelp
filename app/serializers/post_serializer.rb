class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :location, :room, :startTime, :endTime, :taskDetails, :credit, :email, :helperStatus, :helperEmail, :helperComplete, :requesterComplete
end
