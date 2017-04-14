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
    fileprivate let developerNameService: DeveloperNameService
    
    init(other: SessionDelegate, log: SessionLog, developerNameService: DeveloperNameService) {
        self.other = other
        self.log = log
        self.developerNameService = developerNameService
    }
}

extension SessionDelegateLogDecorator: SessionDelegate {
    
    func developerChanged(developer: Developer) {
        
        log.sessionEnded(
            developerName: developerNameService.nameOf(developer: otherDeveloper(developer)),
            otherDeveloperName: developerNameService.nameOf(developer:developer))
        
        other.developerChanged(developer: developer)
    }
    
    func sessionStarted(sessionEndsOn: Date, forDeveloper: Developer, restored: Bool) {
        
        if !restored {
            log.sessionStarted(
                developerName: developerNameService.nameOf(developer: forDeveloper),
                otherDeveloperName: developerNameService.nameOf(developer:otherDeveloper(forDeveloper)))
        }
        
        other.sessionStarted(sessionEndsOn: sessionEndsOn, forDeveloper: forDeveloper, restored: restored)
    }
    
    func sessionEnded(forDeveloper: Developer) {
        
        log.sessionEnded(
            developerName: developerNameService.nameOf(developer: forDeveloper),
            otherDeveloperName: developerNameService.nameOf(developer:otherDeveloper(forDeveloper)))

        other.sessionEnded(forDeveloper: forDeveloper)
    }
    
    func countdownExpired() {
        other.countdownExpired()
    }
    
    private func otherDeveloper(_ developer: Developer) -> Developer {
        
        return developer == .left ? .right : .left
    }
}
