//
//  SessionLogEntry.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 11.04.17.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

struct SessionLogEntry {
    
    var uuid: UUID
    var startedOn: Date
    var endedOn: Date?
    var developerName: String
}
