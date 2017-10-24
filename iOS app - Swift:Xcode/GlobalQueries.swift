//
//  GlobalQueries.swift
//  FortyDayChallenge
//
//  Created by Shane Denham on 11/9/15.
//  Copyright © 2015 Covenent Eyes. All rights reserved.
//

import RealmSwift

class GlobalQueries {
    
    let realm = try! Realm()
    
    // Realm query to get the current day using the dayNumber
    class func setCurrentDay(_ currentDayNumber: Int) -> ChallengeDay {
        let realm = try! Realm()
        let currentDay = realm.objectForPrimaryKey(ChallengeDay.self, key: currentDayNumber)
        
        return currentDay!
    }
    
    // Get "Today's Challenge"
    class func getOpenDay() -> ChallengeDay {
        let realm = try! Realm()
        let openDays = realm.objects(ChallengeDay).filter("progress > 0 AND progress < 4")
        var openDay: ChallengeDay
        if (openDays.count > 0) {
            openDay = openDays[0]
        } else {
            openDay = realm.objectForPrimaryKey(ChallengeDay.self, key: 1)!
        }
        return openDay
    }
    
    // User Exists
    class func userExists() -> Bool {
        let realm = try! Realm()
        let uArray = realm.objects(User).filter("id = 1")
        if (uArray.count > 0) {
            return true
        } else {
            return false
        }
    }

    // Get User
    class func getUser() -> User {
        let realm = try! Realm()
        let uArray = realm.objects(User).filter("id = 1")
        let user = uArray[0]
        return user
    }
    
    // Check for action step data
    class func isActionData() -> Bool {
        let actionDataArray = try! Realm().objects(DayAction)
        
        if actionDataArray.count == 0 {
            return false
        } else  {
            let day2 = actionDataArray[6]
            return !day2.actionContent.isEmpty
        }
    }
    
    // Realm query to get the DayAction data using the current day
    class func getActionDataForCurrentDay(_ currentDay: ChallengeDay) -> Results<(DayAction)> {
        let realm = try! Realm()
        let dayAction = realm.objects(DayAction).filter("day == %@", currentDay)
        
        return dayAction
    }
    
    // Check the number of action steps
    class func areTwoActionSteps(_ currentDay: ChallengeDay) -> Bool {
        let realm = try! Realm()
        let dayAction = realm.objects(DayAction).filter("day == %@", currentDay)
        if dayAction.count > 1 {
            return true
        } else {
            return false
        }
    }
    
    // Update the progress of a challenge day
    class func setProgressForChallengeDays(_ currentDayNumber: Int) {
        let realm = try! Realm()
        
        // Unlock first day
        if currentDayNumber == 0 {
            try! realm.write{
                realm.create(ChallengeDay.self, value: ["dayNumber": 1, "progress": 1], update: true)
            }
        } else {
            
            let currentDay = setCurrentDay(currentDayNumber)
            
            if currentDay.progress < 6 {
                try! realm.write {
                    currentDay.progress = currentDay.progress + 1
                }
            
                if currentDay.progress > 3 {
                
                    let nextDayNumber = currentDayNumber + 1
                
                    let nextDay = realm.objectForPrimaryKey(ChallengeDay.self, key: nextDayNumber)
                
                    if nextDay?.progress == 0 {
                        try! realm.write {
                            nextDay!.progress = 1
                        }
                    }
                }
            }
        }
    }
    
    // Unlock all challenge days for testing
    class func unlockAllDays() {
        let realm = try! Realm()
        let challengeDays = realm.objects(ChallengeDay)
        
        for day in challengeDays {
            try! realm.write{
                day.progress = 1
            }
        }
    }

}
