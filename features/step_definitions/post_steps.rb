# background
Given /the following posts exists/ do |posts_table|
  posts_table.hashes.each do |post|
    Post.create(post)
  end
end

Given /the following comments exists/ do |comments_table|
  comments_table.hashes.each do |comment|
    Comment.create(comment)
  end
end

Given /^(?:|I )am on the LionHelp home page as a logged-in user with email = (.*) and password = (.*)/ do |email, password|
  response = post "/api/v1/login", "email": email, "password": password
  expect(JSON.parse(response.body)['token']).to be_a(String)
  page = visit("/post")
  expect(page["status"]).to eql("success")
end

Then /(.*) seed posts should exist/ do |n_seeds|
  Post.count.should be n_seeds.to_i
end

Then /(.*) seed comments should exist/ do |n_seeds|
  Comment.count.should be n_seeds.to_i
end

# Create a new post
When /^(?:|I )press "Post a new request"/ do
  page = visit("/post")
  expect(page["status"]).to eql("success")
end

When /^(?:|I )fill in (.*) as user (.*)/ do |inputs, email|
  table = Hash.new
  list = inputs.split(", ")
  list.each do |input|
    sp = input.split(" = ")
    table[sp[0]] = sp[1]
  end
  post = {title: table["title"], location: table["location"], credit: table["credit"], startTime: table["startTime"], endTime: table["endTime"], taskDetails: table["taskDetails"], email: email}
  @create_post = post "/api/v1/posts/create", post: post
end

When /^(?:|I )only fill in (.*) as user (.*)/ do |inputs, email|
  table = Hash.new
  list = inputs.split(", ")
  list.each do |input|
    sp = input.split(" = ")
    table[sp[0]] = sp[1]
  end
  @record = Post.new
  @record.title = table["title"]
  @record.location = table["location"]
  @record.credit = table["credit"]
  @record.startTime = table["startTime"]
  @record.endTime = table["endTime"]
  @record.taskDetails = table["taskDetails"]
  @record.email = email
  @record.validate
  expect(@record.errors.messages.has_value?(["can't be blank"])).to eql(true)
end

Then('I create post successful') do
  #expect(@create_post.status).to eql(200)
  expect(Post.count).to eql(3)
end

Then /I create post failed / do
  expect(Post.count).to eql(2)
end

Then('I visit posts index') do
  response = get "/api/v1/posts/index"
  expect(response.status).to eql(200)
end

# Respond to a request
When /^(?:|I )press "Want to Help" for post with ID = (.*)/ do |id|
  page = visit("/spost/#{id}")
  expect(page["status"]).to eql("success")
end

Then /I am on the page which only constains info for post with ID = (.*) and Title = (.*)/ do |id, title|
  response = get "/api/v1/help/#{id}"
  expect(response.status).to eql(200)
end

# See a list of available requests
When /^(?:|I )logged in with email = (.*) and password = (.*)/ do |email, password|
  response = post "/api/v1/login", "email": email, "password": password
  expect(JSON.parse(response.body)['token']).to be_a(String)
end

Then ("I am on the LionHelp homepage") do
  @response2 = get "/api/v1/index"
end

Then /I enter search keyword (.*)/ do |keyword|
  @response2 = get "/api/v1/index/#{keyword}/NA/NA"
end

Then /I choose location filter (.*)/ do |location|
  url = "/api/v1/index/NA/#{location}/NA"
  url = URI.encode_www_form_component(url)
  @response2 = get url
end

Then /I choose to sort by (.*)/ do |sortBy|
  @response2 = get "/api/v1/index/NA/NA/#{sortBy}"
end

Then /I see a list of available requests successfully/ do
  expect(@response2.status).to eql(200)
end

# accept a post
When('I press "Want to Help"') do
  page = visit("/api/v1/posts/help/#{Post.last.id}")
  expect(page["status"]).to eql("success")
  response = get "/api/v1/posts/show/#{Post.last.id}"
  expect(response.status).to eql(200)
end

Then('I redirect to the post show page') do
  page = visit("/spost/#{Post.last.id}")
  expect(page["status"]).to eql("success")
  response = get "/api/v1/posts/help_history"
  expect(response.status).to eql(200)
end

Then(/I visit help history page/) do
  response = post "/api/v1/login", "email": "abd@columbia.edu", "password": 123
  expect(JSON.parse(response.body)['token']).to be_a(String)
  page = visit("/help_history")
  expect(page["status"]).to eql("success")
end

And('I see a post helped') do
  response = post "/api/v1/login", "email": "abd@columbia.edu", "password": 123
  expect(JSON.parse(response.body)['token']).to be_a(String)
  page = visit("/help_history")
  expect(page["status"]).to eql("success")
  expect(Post.where(helperEmail: "abd@columbia.edu").order(created_at: :desc).count).to eql(1)
end

Then('I redirect to the help history page') do
  post "/api/v1/login", "email": "abd@columbia.edu", "password": 123
  page = visit("/help_history")
  expect(page["status"]).to eql("success")
end

When(/I press "Cancel Help"/) do
  response = get "/api/v1/posts/cancel?id=#{Post.last.id}"
  expect(response.status).to eql(200)
end
# Then('I am on the LionHelp home page use another user with email = abc@columbia.edu and password = {int}') do |int|
Then /^(?:|I )am on the LionHelp home page use another user with email = (.*) and password = (.*)/ do |email, password|
  response = post "/api/v1/login", "email": email, "password": password
  expect(JSON.parse(response.body)['token']).to be_a(String)
end

Then('I see a post helped is null') do
  post "/api/v1/login", "email": "abc@columbia.edu", "password": 123
  page = visit("/help_history")
  expect(page["status"]).to eql("success")
  response = get "/api/v1/posts/help_history"
  expect(response.status).to eql(200)
  expect(Post.where(helperEmail: "abc@columbia.edu").order(created_at: :desc).count).to eql(0)
end

Then('I visit pre posts') do
  response = get "/api/v1/posts/pre_posts"
  expect(response.status).to eql(200)
end