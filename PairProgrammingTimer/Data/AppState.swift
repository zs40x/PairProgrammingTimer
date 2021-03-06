//
//  AppState.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 30/03/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

class AppState {
    
    let currentDeveloper: Developer
    let sessionState: SessionState
    let sessionEndsOn: Date
    
    init(currentDeveloper: Developer, sessionState: SessionState, sessionEndsOn: Date) {
        self.currentDeveloper = currentDeveloper
        self.sessionState = sessionState
        self.sessionEndsOn = sessionEndsOn
    }
}
