Feature: Create a new post
  As a student on campus
  So that I can get help from other students based on my need
  I want to publish a post with my information

Background: posts have been added to database

  Given the following posts exists
  | title   | location    | startTime         | endTime           | taskDetails                                 | credit  | email             | helperStatus  | helperEmail             | helperComplete  | requesterComplete |
  | Post 1  | CSC 421     | 14/09/2011 14:09  | 14/09/2011 14:09  | I need a type C charger for about an hour.  | 2.5     | abc@columbia.edu  | true          | abd@columbia.edu        | true            | true              |
  | Post 2  | CSC 421     | 14/09/2011 14:09  | 14/09/2011 14:09  | I need a type C charger for about an hour.  | 2.5     | abd@columbia.edu  | false         | null                    | false           | false             |

  And the following comments exists
  | commenter         | commentee         | content                             | postID  |
  | abc@columbia.edu  | abd@columbia.edu  | Instant Help! Really appreciate it! | 1       |

  And the following users exists
  | id | email             | firstName     | lastName          | password          |
  | 1  | abc@columbia.edu  | bc            | a                 | 123               |
  | 2  | abd@columbia.edu  | bd            | a                 | 123               |

  And I am on the LionHelp home page as a logged-in user with email = abd@columbia.edu and password = 123
  Then 2 seed posts should exist
  And 1 seed comments should exist
  And 2 seed users should exist

Scenario: Add a comment Successfully
  When I press "Show Comments"
  And I see a comment
  And I fill in comment "My first comment"
  Then I create comment successful
  Then I redirect to homepage

