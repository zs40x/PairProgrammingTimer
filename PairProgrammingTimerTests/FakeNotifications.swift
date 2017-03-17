//
//  FakeNotifications.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 17/03/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation
@testable import PairProgrammingTimer

class FakeNotifications: Notifications {
    
    var registered = false
    var pendingCancelled = false
    
    func register() {
        self.registered = true
    }
    
    func cancelPending() {
        self.pendingCancelled = true
    }
}
