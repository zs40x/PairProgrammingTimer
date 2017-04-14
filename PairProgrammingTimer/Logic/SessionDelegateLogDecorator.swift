//
//  SessionDelegateLogDecorator.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 11.04.17.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

class SessionDelegateLogDecorator {
    
    fileprivate let other: SessionDelegate
    fileprivate let log: SessionLog
    
    init(other: SessionDelegate, log: SessionLog) {
        self.other = other
        self.log = log
    }
}

extension SessionDelegateLogDecorator: SessionDelegate {
    
    func developerChanged(developer: Developer) {
        log.sessionEnded()
        other.developerChanged(developer: developer)
    }
    
    func sessionStarted(sessionEndsOn: Date, forDeveloper: Developer) {
        log.sessionStarted(developerName: developerName(forDeveloper), otherDeveloperName: otherDeveloperName(forDeveloper))
        other.sessionStarted(sessionEndsOn: sessionEndsOn, forDeveloper: forDeveloper)
    }
    
    func sessionEnded() {
        log.sessionEnded()
        other.sessionEnded()
    }
    
    func countdownExpired() {
        other.countdownExpired()
    }
    
    private func developerName(_ developer: Developer) -> String {
        let developerNames = AppSettings().developerNames
        
        return developer == .left ? developerNames.left : developerNames.right
    }
    
    private func otherDeveloperName(_ developer: Developer) -> String {
        let developerNames = AppSettings().developerNames
        
        return developer == .left ? developerNames.right : developerNames.left
    }
}
