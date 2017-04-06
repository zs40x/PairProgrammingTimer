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
    var sessionDurationInMinutes: Double { get }
    
    func toggleState() -> Session
    func changeDevelopers() -> Session
    func restoreState(sessionState: SessionState, sessionEndsOn: Date) -> Session
    
    func timeRemaingInSeconds() -> Double
    
    func isEqualTo(otherSession: Session) -> Bool
}

protocol SessionDelegate {
    func developerChanged(developer: Developer)
    func sessionStarted(sessionEndsOn: Date, forDeveloper: Developer)
    func sessionEnded()
    func countdownExpired()
}

class ProgrammingSession: Session {
    
    let developer: Developer
    let sessionEndsOn: Date?
    let sessionDurationInMinutes: Double
    
    fileprivate let delegate: SessionDelegate?
    
    private let timer: CountdownTimer
    private let dateTime: DateTime
    
    init(withDeveloper: Developer, timer: CountdownTimer, sessionEndsOn: Date?, dateTime: DateTime, sessionDurationInMinutes: Double, delegate:SessionDelegate?) {
        self.developer = withDeveloper
        self.timer = timer
        self.sessionEndsOn = sessionEndsOn
        self.dateTime = dateTime
        self.sessionDurationInMinutes = sessionDurationInMinutes
        self.delegate = delegate
    }
    
    convenience init(withDeveloper: Developer, delegate: SessionDelegate?, timer: CountdownTimer, dateTime: DateTime, sessionDurationInMinutes: Double) {
        self.init(withDeveloper: withDeveloper, timer: timer, sessionEndsOn: nil, dateTime: dateTime, sessionDurationInMinutes: sessionDurationInMinutes, delegate: delegate)
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
    
    fileprivate func startSession(sessionEndsOn: Date) -> Session {
        
        timer.start(callDelegateWhenExpired: self)
        
        delegate?.sessionStarted(sessionEndsOn: sessionEndsOn, forDeveloper: developer)
        
        return makeNewInstance(withDeveloper: developer, sessionEndsOn: sessionEndsOn)
    }
    
    private func start() -> Session {
        
        return startSession(sessionEndsOn: dateTime.currentDateTime().addingTimeInterval(sessionDurationInMinutes * 60))
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
    
    func restoreState(sessionState: SessionState, sessionEndsOn: Date) -> Session {
        
        guard sessionState == .active else { return self }
        
        guard sessionEndsOn.timeIntervalSince(dateTime.currentDateTime()) / 60 > -120 else { return self }
        
        return RestoredProgrammingSession(
                    withDeveloper: developer,
                    timer: timer,
                    sessionEndsOn: sessionEndsOn,
                    dateTime: dateTime,
                    sessionDurationInMinutes: sessionDurationInMinutes,
                    delegate: delegate
                ).makeRestoredSession(sessionEndsOn: sessionEndsOn)

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
    
    func isEqualTo(otherSession: Session) -> Bool {
        
        guard let otherProgrammingSession = otherSession as? ProgrammingSession else { return false }
        
        return self.sessionEndsOn == otherProgrammingSession.sessionEndsOn
                && self.developer == otherProgrammingSession.developer
                && self.sessionDurationInMinutes == otherProgrammingSession.sessionDurationInMinutes
                && self.sessionState == otherProgrammingSession.sessionState
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

class RestoredProgrammingSession : ProgrammingSession {
    
    func makeRestoredSession(sessionEndsOn: Date) -> Session {
        
        return startSession(sessionEndsOn: sessionEndsOn)
    }
}
