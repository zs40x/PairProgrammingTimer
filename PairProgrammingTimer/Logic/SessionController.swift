//
//  SessionController.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 23/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

protocol SessionControl {
    func start()
    func stop()
    func changeDevelopers() -> Session
}

class ProgrammingSessionControl: SessionControl {
    
    func start() {
        
    }
    
    func stop() {
        
    }
    
    func changeDevelopers() -> Session {
      
        return DeveloperSession(developer: .left)
    }
}
