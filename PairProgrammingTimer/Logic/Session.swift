//
//  SessionController.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 23/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

protocol Session  {
    var developer: Developer { get }
    var sessionState: SessionState { get }
    var sessionDuration: SessionDuration { get }
    
    func toggleState() -> Session
    func changeDevelopers() -> Session
    func restoreState(sessionState: SessionState, sessionEndsOn: Date) -> Session
    
    func timeRemaingInSeconds() -> Double
    
    func isEqualTo(otherSession: Session) -> Bool
}

protocol SessionDelegate {
    func developerChanged(developer: Developer)
    func sessionStarted(sessionEndsOn: Date, forDeveloper: Developer, restored: Bool)
    func sessionEnded(forDeveloper: Developer)
    func countdownExpired()
}

class ProgrammingSession: Session {
    
    let developer: Developer
    let sessionEndsOn: Date?
    let sessionDuration: SessionDuration
    
    fileprivate let delegate: SessionDelegate?
    
    private let timer: CountdownTimer
    private let dateTime: DateTime
    
    init(withDeveloper: Developer, timer: CountdownTimer, sessionEndsOn: Date?, dateTime: DateTime, sessionDuration: SessionDuration, delegate:SessionDelegate?) {
        self.developer = withDeveloper
        self.timer = timer
        self.sessionEndsOn = sessionEndsOn
        self.dateTime = dateTime
        self.sessionDuration = sessionDuration
        self.delegate = delegate
    }
    
    convenience init(withDeveloper: Developer, delegate: SessionDelegate?, timer: CountdownTimer, dateTime: DateTime, sessionDuration: SessionDuration) {
        self.init(withDeveloper: withDeveloper, timer: timer, sessionEndsOn: nil, dateTime: dateTime, sessionDuration: sessionDuration, delegate: delegate)
    }
    
    var sessionState: SessionState {
        get {
            return sessionEndsOn == nil ? SessionState.idle : SessionState.active
        }
    }
    
    func toggleState() -> Session {
       
        if sessionState == .active {
            return stop()
        }
        
        return start()
    }
    
    fileprivate func startSession(sessionEndsOn: Date, restored: Bool) -> Session {
        
        timer.start(callDelegateWhenExpired: self)
        
        delegate?.sessionStarted(sessionEndsOn: sessionEndsOn, forDeveloper: developer, restored: restored)
        
        return makeNewInstance(withDeveloper: developer, sessionEndsOn: sessionEndsOn)
    }
    
    private func start() -> Session {
        
        return startSession(sessionEndsOn: dateTime.currentDateTime().addingTimeInterval(sessionDuration.TotalSeconds), restored: false)
    }
    
    private func stop() -> Session {
        
        timer.stop()
        
        delegate?.sessionEnded(forDeveloper: developer)
        
        return makeNewInstance(withDeveloper: developer, sessionEndsOn: nil)
    }
    
    func changeDevelopers() -> Session {
      
        let nextDeveloper: Developer = developer == .left ? .right : .left
        
        delegate?.developerChanged(developer: nextDeveloper)
        
        let newSession = makeNewInstance(withDeveloper: nextDeveloper, sessionEndsOn: nil)
        
        return sessionState == .active ? newSession.start() : newSession
    }
    
    func restoreState(sessionState: SessionState, sessionEndsOn: Date) -> Session {
        
        guard sessionState == .active else { return self }
        
        guard sessionEndsOn.timeIntervalSince(dateTime.currentDateTime()) / 60 > -120 else { return self }
        
        return RestoredProgrammingSession(
                    withDeveloper: developer,
                    timer: timer,
                    sessionEndsOn: sessionEndsOn,
                    dateTime: dateTime,
                    sessionDuration: sessionDuration,
                    delegate: delegate
                ).makeRestoredSession(sessionEndsOn: sessionEndsOn)

    }
    
    func timeRemaingInSeconds() -> Double {
        
        guard let sessionEndsOn = sessionEndsOn else { return sessionDuration.TotalSeconds }
        
        let currentDate = dateTime.currentDateTime()
        
        if(currentDate > sessionEndsOn) {
            return DateInterval(start: sessionEndsOn, end: currentDate).duration * -1.0
        } else {
            return DateInterval(start: currentDate, end: sessionEndsOn).duration
        }
    }
    
    func isEqualTo(otherSession: Session) -> Bool {
        
        guard let otherProgrammingSession = otherSession as? ProgrammingSession else { return false }
        
        return self.sessionEndsOn == otherProgrammingSession.sessionEndsOn
                && self.developer == otherProgrammingSession.developer
                && self.sessionDuration == otherProgrammingSession.sessionDuration
                && self.sessionState == otherProgrammingSession.sessionState
    }
    
    private func makeNewInstance(withDeveloper: Developer, sessionEndsOn: Date?) -> ProgrammingSession {
        return ProgrammingSession(
            withDeveloper: withDeveloper,
            timer: timer,
            sessionEndsOn: sessionEndsOn,
            dateTime: dateTime,
            sessionDuration: sessionDuration,
            delegate: delegate)
    }

}

extension ProgrammingSession: CountdownTimerExpiredDelegate {
    
    func timerExpired() {
        
        delegate?.countdownExpired()
    }
}

class RestoredProgrammingSession : ProgrammingSession {
    
    func makeRestoredSession(sessionEndsOn: Date) -> Session {
        
        return startSession(sessionEndsOn: sessionEndsOn, restored: true)
    }
}
