//
//  ProgrammingSession.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 23/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

protocol Session {
    func start()
    func stop()
}

class DeveloperSession: Session {
    
    let developer: Developer
    
    init(developer: Developer) {
        self.developer = developer
    }
    
    func start() {
        
    }
    
    func stop() {
        
    }
}
