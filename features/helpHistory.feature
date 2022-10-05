Feature: Respond to a request
  As a student on campus
  I can choose to help other students based on their requests

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


Scenario: Accept a post
  When I press "Want to Help"
  Then I redirect to the post show page
  Then I visit help history page
  And I see a post helped

Scenario: Cancel help a post
  When I visit help history page
  Then I see a post helped
  When I press "Cancel Help"
  Then I redirect to the help history page
  When I visit help history page
  Then I see a post helped

Scenario: Accept a post and change another account should see nothing
  When I press "Want to Help"
  Then I redirect to the post show page
  When I visit help history page
  Then I see a post helped
  And I am on the LionHelp home page use another user with email = abc@columbia.edu and password = 123
  Then I visit help history page
  Then I see a post helped is null