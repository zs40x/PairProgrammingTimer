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
    
    init(other: SessionDelegate, notifications: Notifications) {
        self.other = other
        self.notifications = notifications
    }
}

extension SessionDelegateNotificationDecorator: SessionDelegate {
    
    func developerChanged(developer: Developer) {
        other.developerChanged(developer: developer)
    }
    
    func sessionStarted(sessionEndsOn: Date, forDeveloper: Developer) {
        notifications.register()
        other.sessionStarted(sessionEndsOn: sessionEndsOn, forDeveloper: forDeveloper)
    }
    
    func sessionEnded() {
        notifications.cancelPending()
        other.sessionEnded()
    }
    
    func countdownExpired() {
        other.countdownExpired()
    }
}
