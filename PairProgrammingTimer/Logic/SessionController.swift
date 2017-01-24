//
//  SessionController.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 23/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

protocol SessionControl {
    var session: Session { get }
    
    func start()
    func stop()
    func changeDevelopers() -> SessionControl
}

class ProgrammingSessionControl: SessionControl {
    
    let session: Session
    private let timer: CountdownTimer
    
    init(withDeveloper: Developer, timer: CountdownTimer) {
        self.session = DeveloperSession(developer: withDeveloper)
        self.timer = timer
    }
    
    convenience init(timer: CountdownTimer) {
        self.init(withDeveloper: .left, timer: timer)
    }
    
    func start() {
        
    }
    
    func stop() {
        
    }
    
    func changeDevelopers() -> SessionControl {
      
        let nextDeveloper: Developer = session.developer == .left ? .right : .left
        
        return ProgrammingSessionControl(withDeveloper: nextDeveloper, timer: timer)
    }
}
