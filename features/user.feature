Feature: User Register and Login
  As a student using LionHelp
  I want to sign up or log in to my LionHelp Account

Background: users have been added to database

  Given the following users exists
  | id | email             | firstName     | lastName          | password          |
  | 1  | abc@columbia.edu  | bc            | a                 | 123               |
  | 2  | abd@columbia.edu  | bd            | a                 | 123               |

  Then 2 seed users should exist

Scenario: Signup unsuccessfully
  When I signup with an invalid email
  Then I signup unsuccessfully

Scenario: Signup successfully
  When I signup with a valid email
  Then I signup successfully

Scenario: API login with incorrect credentials
  Given correct email and password are a@columbia.edu and test1234 respectively
  Then I should not receive an authorization token when logging in with wrong email a@columbia.edu and password test123

Scenario: API login with correct credentials
  Given correct email and password are a@columbia.edu and test1234 respectively
  Then I should receive an authorization token when logging in with email a@columbia.edu and password test1234

Scenario: Update user's first name
  When I change the first name of an existing user with ID 1 to b
  Then the new first name of the user with ID 1 should be b

Scenario: Update user's last name
  When I change the first name of an existing user with ID 1 to a
  Then the new first name of the user with ID 1 should be a
