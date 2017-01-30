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
    var developer: Developer { get }
    var sessionStartedOn: Date? { get }
    
    func start() -> SessionControl
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
    let developer: Developer
    let sessionStartedOn: Date?
    
    private let timer: CountdownTimer
    private let dateTime: DateTime
    
    init(withDeveloper: Developer, timer: CountdownTimer, sessionStartedOn: Date?, dateTime: DateTime) {
        self.developer = withDeveloper
        self.timer = timer
        self.sessionStartedOn = sessionStartedOn
        self.dateTime = dateTime
    }
    
    convenience init(timer: CountdownTimer, dateTime: DateTime) {
        self.init(withDeveloper: .left, timer: timer, sessionStartedOn: nil, dateTime: dateTime)
    }
    
    func start() -> SessionControl {
       
        timer.start(callDelegateWhenExpired: self)
        
        delegate?.sessionStarted()
        
        return ProgrammingSessionControl(withDeveloper: developer, timer: timer, sessionStartedOn: dateTime.currentDateTime(), dateTime: dateTime)
    }
    
    func stop() {
     
        delegate?.sessionEnded()
    }
    
    func changeDevelopers() -> SessionControl {
      
        let nextDeveloper: Developer = developer == .left ? .right : .left
        
        delegate?.developerChanged(developer: nextDeveloper)
        
        return ProgrammingSessionControl(withDeveloper: nextDeveloper, timer: timer, sessionStartedOn: nil, dateTime: dateTime)
    }
}

extension ProgrammingSessionControl: CountdownTimerExpiredDelegate {
    
    func timerExpired() {
        
        delegate?.countdownExpired()
    }
}
