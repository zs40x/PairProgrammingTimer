//
//  Notofication.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 17/03/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

protocol Notifications {
    func register()
    func cancelPending()
}


class LocalNotifications {
    
    
}

extension LocalNotifications: Notifications {
    
    func register() {
        
    }
    
    func cancelPending() {
        
    }
}
