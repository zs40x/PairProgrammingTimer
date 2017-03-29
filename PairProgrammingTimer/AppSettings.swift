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
    
    public func SessionDuration() -> ProgrammingSessionDuration {
        
        return ProgrammingSessionDuration(minutes: ConfiguredSessionDuration())
    }
    
    private func ConfiguredSessionDuration() -> Int {
        let configuredDuration = userDefaults.integer(forKey: ConfigurationKey.SessionDuration.rawValue)
        
        return configuredDuration > 0 ? configuredDuration : defaultDurationInMinutes
    }
    
    public func SaveCurrentDeveloper(_ developer: Developer) {
        
        userDefaults.set(developer.rawValue, forKey: ConfigurationKey.CurrentDeveloper.rawValue)
    }
    
    public func CurrentDeveloper() -> Developer {
        return Developer(rawValue: userDefaults.integer(forKey: ConfigurationKey.CurrentDeveloper.rawValue))!
    }
}
