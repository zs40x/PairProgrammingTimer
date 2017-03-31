//
//  AppSettings.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 28/03/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

private enum ConfigurationKey: String {
    case CurrentDeveloper = "CurrentDeveloper"
    case SessionState = "SessionState"
    case SessionDuration = "session_duration"
}

class AppSettings {
    
    private let defaultDurationInMinutes = 15
    private let userDefaults = UserDefaults()
    
    public var ConfiguredSessionDuration : SessionDuration {
        get {
            let configuredSessionDuration = userDefaults.integer(forKey: ConfigurationKey.SessionDuration.rawValue)
            
            guard configuredSessionDuration > 0 else { return SessionDuration(minutes: defaultDurationInMinutes) }
            
            return SessionDuration(minutes: configuredSessionDuration)
        }
    }
    
    var LastState: AppState {
        get {
            return AppState(
                    currentDeveloper: Developer(rawValue: userDefaults.integer(forKey: ConfigurationKey.CurrentDeveloper.rawValue))!,
                    sessionState: SessionState(rawValue: userDefaults.integer(forKey: ConfigurationKey.SessionState.rawValue))!
                )
        }
        set (appState) {
            userDefaults.set(appState.currentDeveloper.rawValue, forKey: ConfigurationKey.CurrentDeveloper.rawValue)
            userDefaults.set(appState.sessionState.rawValue, forKey: ConfigurationKey.SessionState.rawValue)
        }
    }
}
