//
//  ProgrammingSession.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 23/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

protocol Session {
    var developer: Developer { get }
    var startedOn: Date { get }
    var timeRemaining: Double { get }
    
    func start()
    func stop()
}

class DeveloperSession: Session {
    
    let developer: Developer
    let startedOn: Date
    private let dateTime: DateTime
    
    var timeRemaining: Double {
        get {
            return 0.0
        }
    }
    
    init(developer: Developer, startedOn: Date, dateTime: DateTime) {
        self.developer = developer
        self.startedOn = startedOn
        self.dateTime = dateTime
    }
    
    func start() {
        
    }
    
    func stop() {
        
    }
}
