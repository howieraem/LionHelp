# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Post.destroy_all
Comment.destroy_all
2.times do |i|
    Post.create(
      title: "Post #{i + 1}",
      location: "CSC 421",
      startTime: "09/13/2011 14:09",
      endTime: "09/14/2011 14:09",
      taskDetails: "My computer is running out of battery. I need a type C charger for about an hour.",
      credit: 2.5,
      email: "xxxxx@columbia.edu",
      helperStatus: false,
      helperEmail: "null",
      helperComplete: false,
      requesterComplete: false,
      )
    Comment.create(
      commenter: "abc@columbia.edu",
      commentee: "xxxxx@columbia.edu",
      content: "Instant Help! Really appreciate it!",
      postID: 101,
      )
end
