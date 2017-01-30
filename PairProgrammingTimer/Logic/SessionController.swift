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
    var sessionEndsOn: Date? { get }
    
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
    let sessionEndsOn: Date?
    
    private let timer: CountdownTimer
    private let dateTime: DateTime
    private let sessionDurationInMinutes: Double
    
    init(withDeveloper: Developer, timer: CountdownTimer, sessionEndsOn: Date?, dateTime: DateTime, sessionDurationInMinutes: Double) {
        self.developer = withDeveloper
        self.timer = timer
        self.sessionEndsOn = sessionEndsOn
        self.dateTime = dateTime
        self.sessionDurationInMinutes = sessionDurationInMinutes
    }
    
    convenience init(timer: CountdownTimer, dateTime: DateTime, sessionDurationInMinutes: Double) {
        self.init(withDeveloper: .left, timer: timer, sessionEndsOn: nil, dateTime: dateTime, sessionDurationInMinutes: sessionDurationInMinutes)
    }
    
    func start() -> SessionControl {
       
        timer.start(callDelegateWhenExpired: self)
        
        delegate?.sessionStarted()
        
        let sessionEndsOn = dateTime.currentDateTime().addingTimeInterval(sessionDurationInMinutes * 60)
        
        return makeNewInstance(withDeveloper: developer, sessionEndsOn: sessionEndsOn)
    }
    
    func stop() {
     
        delegate?.sessionEnded()
    }
    
    func changeDevelopers() -> SessionControl {
      
        let nextDeveloper: Developer = developer == .left ? .right : .left
        
        delegate?.developerChanged(developer: nextDeveloper)
        
        return makeNewInstance(withDeveloper: nextDeveloper, sessionEndsOn: nil)
    }
    
    func makeNewInstance(withDeveloper: Developer, sessionEndsOn: Date?) -> ProgrammingSessionControl {
        return ProgrammingSessionControl(withDeveloper: withDeveloper, timer: timer, sessionEndsOn: sessionEndsOn, dateTime: dateTime, sessionDurationInMinutes: sessionDurationInMinutes)
    }
}

extension ProgrammingSessionControl: CountdownTimerExpiredDelegate {
    
    func timerExpired() {
        
        delegate?.countdownExpired()
    }
}
