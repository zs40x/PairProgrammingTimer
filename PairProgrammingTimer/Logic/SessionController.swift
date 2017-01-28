//
//  SessionController.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 23/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

protocol SessionControl {
    var delegate: SessionControlDelegate? { get set }
    var session: Session { get }
    
    func start()
    func stop()
    func changeDevelopers() -> SessionControl
}

protocol SessionControlDelegate {
    func developerChanged(developer: Developer)
    func sessionStarted()
    func sessionEnded()
    func countdownExpired()
}

class ProgrammingSessionControl: SessionControl {
    
    var delegate: SessionControlDelegate?
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
       
        timer.start(callDelegateWhenExpired: self)
        
        delegate?.sessionStarted()
    }
    
    func stop() {
     
        delegate?.sessionEnded()
    }
    
    func changeDevelopers() -> SessionControl {
      
        let nextDeveloper: Developer = session.developer == .left ? .right : .left
        
        delegate?.developerChanged(developer: nextDeveloper)
        
        return ProgrammingSessionControl(withDeveloper: nextDeveloper, timer: timer)
    }
}

extension ProgrammingSessionControl: CountdownTimerExpiredDelegate {
    
    func timerExpired() {
        
        delegate?.countdownExpired()
    }
}
