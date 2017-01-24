//
//  FakeSessionControlDelegate.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 24/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation
@testable import PairProgrammingTimer

class FakeSessionControlDelegate: SessionControlDelegate {
    
    private(set) var sessionStartedWasCalled = false
    private(set) var countdownExpiredWasCalled = false
    
    func sessionStarted() {
        sessionStartedWasCalled = true
    }
    
    func countdownExpired() {
        countdownExpiredWasCalled = true
    }
}
