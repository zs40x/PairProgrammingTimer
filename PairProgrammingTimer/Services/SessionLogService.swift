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
    func updateLogEntry(_ logEntry: SessionLogEntry)
    func clearLog()
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
        
        persistSessionLogEntriesAsJson(logEntries)
    }
    
    func updateLogEntry(_ logEntry: SessionLogEntry) {
        
        var logEntries = allLogEntries().filter { $0.uuid != logEntry.uuid }
        
        logEntries.append(logEntry)
        
        persistSessionLogEntriesAsJson(logEntries)
    }
    
    func clearLog() {
        persistSessionLogEntriesAsJson([SessionLogEntry]())
    }
    
    func exportToFileSystem() throws -> URL? {
        
        let jsonStringArray = allLogEntries().map { $0.jsonRepresentation }
        
        guard let data = try? JSONSerialization.data(withJSONObject: jsonStringArray, options: []) else { return nil }
        
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let fileUrl = path.appendingPathComponent("PairProgTimerLog.json")
        
        try data.write(to: fileUrl, options: [])
        
        return fileUrl
    }
    
    private func persistSessionLogEntriesAsJson(_ logEntries: [SessionLogEntry]) {
        
        let jsonStringArray = logEntries.map { $0.jsonRepresentation }
        
        UserDefaults.standard.set(jsonStringArray, forKey: "sessionLogEntries")
    }
}
