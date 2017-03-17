//
//  Notofication.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 17/03/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation
import UserNotifications


protocol Notifications {
    func register()
    func cancelPending()
}

// ToDo: empty implementation when notifications are disabled


class LocalNotifications: Notifications {
    
    private let timeInterval: Double
    
    init(timeInterval: Double) {
        self.timeInterval = timeInterval
    }
 
    func register() {
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "PairProgrammingTimer"
        content.body = "Session timer expired!"
        content.sound = UNNotificationSound.default()

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.timeInterval, repeats: false)
        
        let identifier = "TimeExpired"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
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
    }
}
