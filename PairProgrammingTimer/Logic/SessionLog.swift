//
//  SessionLog.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 11.04.17.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

protocol SessionLogDelegate {
    func logUpdated()
}

class SessionLog {
    
    private let dateTime: DateTime
    private let sessionLogService: SessionLogService
    
    var delegate: SessionLogDelegate?
    
    
    init(dateTime: DateTime, sessionLogService: SessionLogService) {
        self.dateTime = dateTime
        self.sessionLogService = sessionLogService
    }
    
    var entries:  [SessionLogEntry] {
        get {
            return sessionLogService.allLogEntries()
        }
    }
 
    func sessionStarted(developerName: String, otherDeveloperName: String, duration: SessionDuration) {
    
        sessionLogService.addNewLogEntry(
            SessionLogEntry(
                uuid: UUID(),
                startedOn: dateTime.currentDateTime(),
                endedOn: nil,
                plannedDuration: duration,
                developerName: developerName,
                otherDeveloperName: otherDeveloperName))
        
        delegate?.logUpdated()
    }
    
    func sessionEnded(developerName: String, otherDeveloperName: String) {
        
        guard var lastEntry = sessionLogService.allLogEntries().last else { return }
        guard lastEntry.endedOn == nil else { return }
        
        lastEntry.developerName = developerName
        lastEntry.otherDeveloperName = otherDeveloperName
        lastEntry.endedOn = dateTime.currentDateTime()
        sessionLogService.updateLogEntry(lastEntry)
        
        delegate?.logUpdated()
    }
}
