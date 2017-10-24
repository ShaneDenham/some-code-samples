//
//  ChallengeDays.swift
//  FortyDayChallenge
//
//  Created by Shane Denham on 9/2/15.
//  Copyright (c) 2015 Covenent Eyes. All rights reserved.
//

import Foundation
import RealmSwift

class ChallengeDay: Object {
    dynamic var name = ""
    dynamic var dayNumber = 1
    dynamic var imageFile = ""
    dynamic var dayIntro = ""
    dynamic var progress: Int = 0
    dynamic var actionStep = ""
    dynamic var reflectionQuestion = ""
    
    override static func primaryKey() -> String? {
        return "dayNumber"
    }
}

class User: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var email = ""
    dynamic var passcode = ""
    dynamic var usePasscode = "Y"
    dynamic var useAlerts = "Y"
    dynamic var date = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class DayAction: Object {
    dynamic var actionID = 0
    dynamic var actionTitle = ""
    dynamic var actionContent = ""
    dynamic var day: ChallengeDay?
    
    override static func primaryKey() -> String? {
        return "actionID"
    }
}

class UserReflection: Object {
    dynamic var reflection = ""
    dynamic var question1 : Float = 50.00
    dynamic var question2 : Float = 50.00
    dynamic var question3 : Float = 50.00
    
    dynamic var day: ChallengeDay?
}
