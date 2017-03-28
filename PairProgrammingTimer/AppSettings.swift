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

class AppSettings {
    
    private let defaultDurationInMinutes = 15
    
    public func SessionDuration() -> ProgrammingSessionDuration {
        
        return ProgrammingSessionDuration(minutes: ConfiguredSessionDuration())
    }
    
    private func ConfiguredSessionDuration() -> Int {
        let configuredDuration = UserDefaults().integer(forKey: "session_duration")
        
        return configuredDuration > 0 ? configuredDuration : defaultDurationInMinutes
    }
}
