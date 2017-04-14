//
//  SessionDelegateNotificationDelegate.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 17/03/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

class SessionDelegateNotificationDecorator {
    
    fileprivate let other: SessionDelegate
    fileprivate let notifications: Notifications
    fileprivate let developerNameService: DeveloperNameService
    
    init(other: SessionDelegate, notifications: Notifications, developerNameService: DeveloperNameService) {
        self.other = other
        self.notifications = notifications
        self.developerNameService = developerNameService
    }
}

extension SessionDelegateNotificationDecorator: SessionDelegate {
    
    func developerChanged(developer: Developer) {
        other.developerChanged(developer: developer)
    }
    
    func sessionStarted(sessionEndsOn: Date, forDeveloper: Developer, restored: Bool) {
        notifications.register(developerName: developerNameService.nameOf(developer: forDeveloper))
        other.sessionStarted(sessionEndsOn: sessionEndsOn, forDeveloper: forDeveloper, restored: restored)
    }
    
    func sessionEnded(forDeveloper: Developer) {
        notifications.cancelPending()
        other.sessionEnded(forDeveloper: forDeveloper)
    }
    
    func countdownExpired() {
        other.countdownExpired()
    }
}
