FactoryBot.define do
    factory :post do
        title {"Post 1"}
        location {"CSC 421"}
        startTime {"11/09/2011 14:09"}
        endTime {"11/09/2011 14:09"}
        taskDetails {"xxx"}
        credit { 2.5 }
        email {"xxxxx@columbia.edu"}
        helperStatus {false}
        helperEmail {"null"}
        helperComplete {false}
        requesterComplete {false}
    end
end
