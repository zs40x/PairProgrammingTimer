//
//  Notofication.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 17/03/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation
import UserNotifications

struct Notification {
    struct Action {
        static let stopSession = "stopSession"
        static let changeDeveloper = "changeDeveloper"
    }
    struct Category {
        static let sessionExpired = "sessionExpired"
    }
}

protocol Notifications {
    func register(developerName: String)
    func cancelPending()
}

class LocalNotifications: Notifications {
    
    private let notificationIdentifier = "PPTimer_TimerExpired"
    private let timeInterval: Double
    
    init(timeInterval: Double) {
        self.timeInterval = timeInterval
    }
 
    func register(developerName: String) {
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "PairProgrammingTimer"
        content.body = "@" + developerName + " -> " + NSLocalizedString("SessionTimerExpired", comment: "Session timer expired!")
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = Notification.Category.sessionExpired

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: self.notificationIdentifier, content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                NSLog("Error creating notification: \(error)")
                return;
            }
            
            NSLog("Local notification added")
        })
        
    }
    
    func cancelPending() {
        
        let center = UNUserNotificationCenter.current()
        
        center.removeAllPendingNotificationRequests()
        
        NSLog("Eventually pending local notifications removed")
    }
}
