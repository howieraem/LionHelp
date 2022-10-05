Feature: Create a new post
  As a student on campus
  I want to get help from other students based on my need
  So that I  publish a post with my information

Background: posts have been added to database

  Given the following posts exists
  | title   | location                | room            | startTime         | endTime           | taskDetails                                 | credit  | email             | helperStatus  | helperEmail             | helperComplete  | requesterComplete |
  | Post 1  | BAR - Barnard Hall      | Room 201        | 14/09/2011 14:09  | 14/09/2011 14:09  | I need a type C charger for about an hour.  | 2.5     | abc@columbia.edu  | true          | abd@columbia.edu        | true            | true              |
  | Post 2  | BAR - Barnard Hall      | Room 201        | 14/09/2011 14:09  | 14/09/2011 14:09  | I need a type C charger for about an hour.  | 2.5     | abd@columbia.edu  | false         | null                    | false           | false             |

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

Scenario: Add a new post Successfully
  When I press "Post a new request"
  And I fill in title = Post 1, location = AVH - Avery Hall, room = Room 201, credit = 2.0, startTime = 14/09/2011 14:09, endTime = 14/09/2011 15:09, taskDetails = I need a iphone charger! as user abd@columbia.edu
  Then I create post successful

Scenario: Add a new post Successfully
  When I press "Post a new request"
  And I fill in title = Post 1, location = AVH - Avery Hall, room = Room 201, credit = 2.0, startTime = 14/09/2011 14:09, endTime = 14/09/2011 15:09, taskDetails = No more info provided. as user abd@columbia.edu
  Then I create post successful

Scenario: Add a new post Unsuccessfully
  When I press "Post a new request"
  And I only fill in location = AVH - Avery Hall, room = Room 201, startTime = 14/09/2011 14:09, endTime = 14/09/2011 15:09, taskDetails = I need a iphone charger! as user abd@columbia.edu
  Then I create post failed because of missing required info - title

Scenario: Add a new post Unsuccessfully
  When I press "Post a new request"
  And I only fill in title = Post 1, room = Room 201, startTime = 14/09/2011 14:09, endTime = 14/09/2011 15:09, taskDetails = I need a iphone charger! as user abd@columbia.edu
  Then I create post failed because of missing required info - location

Scenario: Add a new post Unsuccessfully
  When I press "Post a new request"
  And I only fill in title = Post 1, location = AVH - Avery Hall, startTime = 14/09/2011 14:09, endTime = 14/09/2011 15:09, taskDetails = I need a iphone charger! as user abd@columbia.edu
  Then I create post failed because of missing required info - location details

Scenario: Add a new post Unsuccessfully
  When I press "Post a new request"
  And I only fill in title = Post 1, location = AVH - Avery Hall, room = Room 201, startTime = 14/09/2011 14:09, endTime = 14/09/2011 15:09 as user abd@columbia.edu
  Then I create post failed because of missing required info - credit
