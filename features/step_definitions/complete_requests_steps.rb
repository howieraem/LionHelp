When /I visit help_history page/ do
  response = get api_v1_posts_help_history_path
  expect(response.status).to eql(200)
  expect(JSON.parse(response.body)[0]["title"]).to eql("Post 1")
end

Then /I see a helped request/ do
  response = post "/api/v1/login", "email": "abd@columbia.edu", "password": 123
  expect(JSON.parse(response.body)['token']).to be_a(String)
  page = visit("/help_history")
  expect(page["status"]).to eql("success")
  expect(Post.where(helperEmail: "abd@columbia.edu").count).to eql(1)
end

When /I press "Complete"/ do
  response = get api_v1_posts_complete_path(id: 1)
  expect(response.status).to eql(200)
end

Then /I see a completed request/ do
  expect(Post.where(requesterComplete: true).count).to eql(1)
end




When "I fill in comment {string}" do |string|
  response = post api_v1_posts_comment_path(content: "test content", postID: 1, commenter: "test commenter")
  expect(response.status).to eql(200)
  expect(JSON.parse(response.body)['message']).to eq('ok')
end

Then /I create comment successful/ do
  Comment.where(postID: 1).count.should be 2
end

Then /I redirect to homepage/ do
  response = get root_path
  expect(response.status).to eql(200)
end