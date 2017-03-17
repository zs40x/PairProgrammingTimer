//
//  SessionDelegateNotificationDelegate.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 17/03/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

class SessionDelegateNotificationDecorator {
    
    private let other: SessionDelegate
    private let notifications: Notifications
    
    init(other: SessionDelegate, notifications: Notifications) {
        self.other = other
        self.notifications = notifications
    }
}

extension SessionDelegateNotificationDecorator: SessionDelegate {
    
    func developerChanged(developer: Developer) {
        
    }
    
    func sessionStarted() {
        
    }
    
    func sessionEnded() {
        
    }
    
    func countdownExpired() {
        
    }
}
