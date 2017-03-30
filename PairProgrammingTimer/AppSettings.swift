//
//  AppSettings.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 28/03/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

struct ProgrammingSessionDuration {
    let TotalMinutes: Double
    let TotalSeconds: Double
    
    init(minutes: Int) {
        self.TotalMinutes = Double(minutes)
        self.TotalSeconds = Double(minutes * 60)
    }
}

private enum ConfigurationKey: String {
    case CurrentDeveloper = "CurrentDeveloper"
    case SessionDuration = "session_duration"
}

class AppSettings {
    
    private let defaultDurationInMinutes = 15
    private let userDefaults = UserDefaults()
    
    public var SessionDuration : ProgrammingSessionDuration {
        get {
            let configuredSessionDuration = userDefaults.integer(forKey: ConfigurationKey.SessionDuration.rawValue)
            
            guard configuredSessionDuration > 0 else { return ProgrammingSessionDuration(minutes: defaultDurationInMinutes) }
            
            return ProgrammingSessionDuration(minutes: configuredSessionDuration)
        }
    }
    
    var CurrentDeveloper: Developer {
        get {
            return Developer(rawValue: userDefaults.integer(forKey: ConfigurationKey.CurrentDeveloper.rawValue))!
        }
        set (developer) {
            userDefaults.set(developer.rawValue, forKey: ConfigurationKey.CurrentDeveloper.rawValue)
        }
    }
}
