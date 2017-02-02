//
//  SessionController.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 23/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

enum SessionState: Int {
    case idle = 0
    case active
}

protocol Session {
    var developer: Developer { get }
    var sessionState: SessionState { get }
    
    func toggleState() -> Session
    
    func changeDevelopers() -> Session
    func timeRemaingInSeconds() -> Double
}

protocol SessionDelegate {
    func developerChanged(developer: Developer)
    func sessionStarted()
    func sessionEnded()
    func countdownExpired()
}

class ProgrammingSession: Session {
    
    let developer: Developer
    
    fileprivate let delegate: SessionDelegate?
    
    private let sessionEndsOn: Date?
    private let timer: CountdownTimer
    private let dateTime: DateTime
    private let sessionDurationInMinutes: Double
    
    
    init(withDeveloper: Developer, timer: CountdownTimer, sessionEndsOn: Date?, dateTime: DateTime, sessionDurationInMinutes: Double, delegate:SessionDelegate?) {
        self.developer = withDeveloper
        self.timer = timer
        self.sessionEndsOn = sessionEndsOn
        self.dateTime = dateTime
        self.sessionDurationInMinutes = sessionDurationInMinutes
        self.delegate = delegate
    }
    
    convenience init(delegate: SessionDelegate?, timer: CountdownTimer, dateTime: DateTime, sessionDurationInMinutes: Double) {
        self.init(withDeveloper: .left, timer: timer, sessionEndsOn: nil, dateTime: dateTime, sessionDurationInMinutes: sessionDurationInMinutes, delegate: delegate)
    }
    
    var sessionState: SessionState {
        get {
            return sessionEndsOn == nil ? SessionState.idle : SessionState.active
        }
    }
    
    func toggleState() -> Session {
       
        if sessionEndsOn != nil {
            return stop()
        }
        
        return start()
    }
    
    private func start() -> Session {
        
        timer.start(callDelegateWhenExpired: self)
        
        delegate?.sessionStarted()
        
        let sessionEndsOn = dateTime.currentDateTime().addingTimeInterval(sessionDurationInMinutes * 60)
        
        return makeNewInstance(withDeveloper: developer, sessionEndsOn: sessionEndsOn)
    }
    
    private func stop() -> Session {
        
        timer.stop()
        
        delegate?.sessionEnded()
        
        return makeNewInstance(withDeveloper: developer, sessionEndsOn: nil)
    }
    
    func changeDevelopers() -> Session {
      
        let nextDeveloper: Developer = developer == .left ? .right : .left
        
        delegate?.developerChanged(developer: nextDeveloper)
        
        let newSession = makeNewInstance(withDeveloper: nextDeveloper, sessionEndsOn: nil)
        
        return sessionState == .active ? newSession.start() : newSession
    }
    
    func timeRemaingInSeconds() -> Double {
        
        guard let sessionEndsOn = sessionEndsOn else { return sessionDurationInMinutes * 60 }
        
        let currentDate = dateTime.currentDateTime()
        
        if(currentDate > sessionEndsOn) {
            return DateInterval(start: sessionEndsOn, end: currentDate).duration * -1.0
        } else {
            return DateInterval(start: currentDate, end: sessionEndsOn).duration
        }
    }
    
    private func makeNewInstance(withDeveloper: Developer, sessionEndsOn: Date?) -> ProgrammingSession {
        return ProgrammingSession(
            withDeveloper: withDeveloper,
            timer: timer,
            sessionEndsOn: sessionEndsOn,
            dateTime: dateTime,
            sessionDurationInMinutes: sessionDurationInMinutes,
            delegate: delegate)
    }
}

extension ProgrammingSession: CountdownTimerExpiredDelegate {
    
    func timerExpired() {
        
        delegate?.countdownExpired()
    }
}
