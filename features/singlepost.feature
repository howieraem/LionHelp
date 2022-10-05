Feature: Respond to a request
  As a student using LionHelp
  I want to respond to a request

Background: posts have been added to database

  Given the following posts exists
  | id  | title   | location    | startTime         | endTime           | taskDetails                                 | credit  | email             | helperStatus  | helperEmail             | helperComplete  | requesterComplete |
  | 1   | Post 1  | CSC 421     | 14/09/2011 14:09  | 14/09/2011 14:09  | I need a type C charger for about an hour.  | 2.5     | abc@columbia.edu  | true          | abd@columbia.edu        | true            | true              |
  | 2   | Post 2  | CSC 421     | 14/09/2011 14:09  | 14/09/2011 14:09  | I need a type C charger for about an hour.  | 2.5     | abd@columbia.edu  | false         | null                    | false           | false             |

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

Scenario:  Respond to a request successfully
When I press "Want to Help" for post with ID = 2
Then I am on the page which only constains info for post with ID = 2 and Title = Post 2