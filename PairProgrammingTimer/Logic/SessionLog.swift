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
    private(set) var entries = [SessionLogEntry]()
    
    var delegate: SessionLogDelegate?
    
    
    init(dateTime: DateTime) {
        self.dateTime = dateTime
    }
 
    func sessionStarted(forDeveloper: Developer) {
    
        endLastEntry()
        
        entries.append(
            SessionLogEntry(
                uuid: UUID(),
                startedOn: dateTime.currentDateTime(),
                endedOn: nil,
                developerName: "n/a"))
        
        delegate?.logUpdated()
    }
    
    func sessionEnded() {
        
        endLastEntry()
        
        delegate?.logUpdated()
    }
    
    private func endLastEntry() {
        
        guard var lastEntry = entries.last else { return }
        guard lastEntry.endedOn == nil else { return }
        
        entries.removeLast()
        lastEntry.endedOn = dateTime.currentDateTime()
        entries.append(lastEntry)
    }
}
