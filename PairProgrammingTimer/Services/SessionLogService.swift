//
//  LogService.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 14.04.17.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

protocol SessionLogService {
    func allLogEntries() -> [SessionLogEntry]
    func addNewLogEntry(_ newLogEntry: SessionLogEntry)
}

class SessionUserDefaultsLogService: SessionLogService {
    
    func allLogEntries() -> [SessionLogEntry] {
        
        guard let logEntryJsonStringArray = UserDefaults.standard.value(forKey: "sessionLogEntries") as? [String] else {
            NSLog("No logEntries in userDefaults found")
            return [SessionLogEntry]()
        }
        
        return logEntryJsonStringArray.flatMap({ SessionLogEntry(json: $0) })
    }
    
    func addNewLogEntry(_ newLogEntry: SessionLogEntry) {
        
        var logEntries = allLogEntries()
        
        logEntries.append(newLogEntry)
        
        let jsonStringArray = logEntries.map { $0.jsonRepresentation }
        
        UserDefaults.standard.set(jsonStringArray, forKey: "sessionLogEntries")
    }
}
