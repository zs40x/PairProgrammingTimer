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
    func changeDevelopers() -> SessionControl
}

class ProgrammingSessionControl: SessionControl {
    
    let session: Session
    
    init(withDeveloper: Developer) {
        self.session = DeveloperSession(developer: withDeveloper)
    }
    
    convenience init() {
        self.init(withDeveloper: .left)
    }
    
    
    func start() {
        
    }
    
    func stop() {
        
    }
    
    func changeDevelopers() -> SessionControl {
      
        return ProgrammingSessionControl(withDeveloper: .left)
    }
}
