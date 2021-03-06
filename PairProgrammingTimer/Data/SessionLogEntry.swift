//
//  SessionLogEntry.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 11.04.17.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

struct SessionLogEntry {
    
    private var _endedOn: Date?
    
    var uuid: UUID
    var startedOn: Date
    var endedOn: Date? {
        get {
            guard let endedOn = _endedOn else { return nil }
            guard endedOn >= startedOn else { return nil }
            return endedOn
        }
        set(newEndedOn) {
            _endedOn = newEndedOn
        }
    }
    var plannedDuration: SessionDuration
    var developerName: String
    var otherDeveloperName: String
    
    init(uuid: UUID, startedOn: Date, endedOn: Date?, plannedDuration: SessionDuration, developerName: String, otherDeveloperName: String) {
        self.uuid = uuid
        self.startedOn = startedOn
        self._endedOn = endedOn
        self.plannedDuration = plannedDuration
        self.developerName = developerName
        self.otherDeveloperName = otherDeveloperName
    }
    
    init?(json : String) {
        
        guard let data = json.data(using: .utf8),
            let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:String],
            let uuid = jsonDict?["uuid"],
            let startedOn = jsonDict?["startedOn"],
            let endedOn = jsonDict?["endedOn"],
            let plannedDuration = jsonDict?["plannedDuration"],
            let developerName = jsonDict?["developerName"],
            let otherDeveloperName = jsonDict?["otherDeveloperName"]
            else { return nil }
        
        self.init(
            uuid: UUID.init(uuidString: uuid) ?? UUID(),
            startedOn: Date(timeIntervalSince1970: Double(startedOn) ?? 0),
            endedOn: Date(timeIntervalSince1970: Double(endedOn) ?? 0),
            plannedDuration: SessionDuration(minutes: Int(Double(plannedDuration) ?? 0)),
            developerName: developerName,
            otherDeveloperName: otherDeveloperName
        )
    }
    
    var jsonRepresentation : String {
        
        let jsonDict =
            [
                "uuid": uuid.uuidString,
                "startedOn" : String(startedOn.timeIntervalSince1970),
                "endedOn" : String(endedOn?.timeIntervalSince1970 ?? 0),
                "plannedDuration" : String(plannedDuration.TotalMinutes),
                "developerName" : developerName,
                "otherDeveloperName" : otherDeveloperName
        ]
        
        if let data = try? JSONSerialization.data(withJSONObject: jsonDict, options: []),
            let jsonString = String(data:data, encoding:.utf8) {
            return jsonString
        } else { return "" }
    }
    
    var actualDuration: Double {
        get {
            guard let endedOn = endedOn else { return 0 }
        
            return Double(endedOn.timeIntervalSince(startedOn) / 60)
        }
    }
    
    var durationDifference: Double {
        get {
            guard actualDuration > 0 else { return 0 }
            
            return (plannedDuration.TotalMinutes - actualDuration) * -1
        }
    }
}
