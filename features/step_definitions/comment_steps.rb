When /I press "Show Comments"/ do
  page = visit("/post")
  expect(page["status"]).to eql("success")
end

When /I see a comment/ do
  Comment.where(postID: 1).count.should be 1
end




