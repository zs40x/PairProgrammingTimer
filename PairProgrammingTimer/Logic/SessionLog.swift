//
//  SessionLog.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 11.04.17.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

class SessionLog {
    
    fileprivate(set) var entries = [SessionLogEntry]()
}

extension SessionLog: SessionDelegate {
    
    func sessionStarted(sessionEndsOn: Date, forDeveloper: Developer) {
    
        entries.append(
            SessionLogEntry(
                uuid: UUID(),
                startedOn: Date(),
                endedOn: nil,
                developerName: "n/a"))
    }
    
    func sessionEnded() {
        
        guard var lastEntry = entries.last else { return }
        
        lastEntry.endedOn = Date()
    }
    
    func countdownExpired() { }
    
    func developerChanged(developer: Developer) { }
}
