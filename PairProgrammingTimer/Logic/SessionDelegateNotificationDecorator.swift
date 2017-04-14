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
    
    func sessionStarted(sessionEndsOn: Date, forDeveloper: Developer, restored: Bool) {
        notifications.register(developerName: developerName(forDeveloper))
        other.sessionStarted(sessionEndsOn: sessionEndsOn, forDeveloper: forDeveloper, restored: restored)
    }
    
    func sessionEnded(forDeveloper: Developer) {
        notifications.cancelPending()
        other.sessionEnded(forDeveloper: forDeveloper)
    }
    
    func countdownExpired() {
        other.countdownExpired()
    }
    
    private func developerName(_ developer: Developer) -> String {
        let developerNames = AppSettings().developerNames
        
        return developer == .left ? developerNames.left : developerNames.right
    }
}
