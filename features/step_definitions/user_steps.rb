# background
Given /the following users exists/ do |users_table|
  users_table.hashes.each do |user|
    User.create(user)
  end
end

Then /(.*) seed users should exist/ do |n_seeds|
  User.count.should be n_seeds.to_i
end


# signup
When /I signup with an invalid email/ do
  response = post "/api/v1/signup", email: "admin@gmail.edu", firstName: "a", lastName: "b", password: "test1234"
  expect(JSON.parse(response.body)["error"]).to eql('Email wrong format, please use your LionMail.')
end

Then /I signup unsuccessfully/ do
  expect(User.count).to eql(2)
end

When /I signup with a valid email/ do
  response = post "/api/v1/signup", email: "admin20@columbia.edu", firstName: "a", lastName: "b", password: "test1234"
  expect(JSON.parse(response.body)['token']).to be_a(String)
end

Then /I signup successfully/ do
  expect(User.count).to eql(3)
end


# login
Given /email and password are (.*) and (.*) respectively/ do |email, password|
  User.create(email: email, password: password, firstName: "a", lastName: "b")
end

Then /should receive an authorization token when logging in with email (.*) and password (.*)/ do |email, password|
  response = post "/api/v1/login", "email": email, "password": password
  expect(JSON.parse(response.body)['token']).to be_a(String)
end

Then /not receive an authorization token when logging in with wrong email (.*) and password (.*)/ do |email, password|
  response = post "/api/v1/login", "email": email, "password": password
  expect(JSON.parse(response.body)['token']).to be_nil
end


# Update user profile
When /change the first name of an existing user with ID (\d+) to (.*)/ do |id, newName|
  put "/api/v1/users/" + id.to_s, firstName: newName
end

Then /the new first name of the user with ID (\d+) should be (.*)/ do |id, newName|
  expect(User.find(id.to_s).firstName).to eq(newName)
end

When /change the last name of an existing user with ID (\d+) to (.*)/ do |id, newName|
  put "/api/v1/users/" + id.to_s, lastName: newName
end

Then /the new last name of the user with ID (\d+) should be (.*)/ do |id, newName|
  expect(User.find(id.to_s).lastName).to eq(newName)
end
