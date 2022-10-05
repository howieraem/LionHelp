FactoryBot.define do
    factory :comment do
        commenter { "admin@columbia.edu" }
        commentee { "a@columbia.edu" }
        content { "Instant Help! Really appreciate it!" }
        postID { 1 }
    end
end