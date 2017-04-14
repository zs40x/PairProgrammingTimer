//
//  FakeSessionLogService.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 14.04.17.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation
@testable import PairProgrammingTimer

class FakeSessionLogService: SessionLogService {
    
    private var entries = [SessionLogEntry]()
    
    func allLogEntries() -> [SessionLogEntry] {
        return entries
    }
    
    func addNewLogEntry(_ newLogEntry: SessionLogEntry) {
        entries.append(newLogEntry)
    }
    
    func updateLogEntry(_ logEntry: SessionLogEntry) {
        entries = entries.filter { $0.uuid != logEntry.uuid }
        entries.append(logEntry)
    }
}
