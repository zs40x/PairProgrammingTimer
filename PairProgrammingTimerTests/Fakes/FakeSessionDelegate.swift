//
//  FakeSessionControlDelegate.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 24/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation
@testable import PairProgrammingTimer

class FakeSessionDelegate: SessionDelegate {
    
    private(set) var developerChangedWasCalled = false
    private(set) var sessionStartedWasCalled = false
    private(set) var sessionEndedWasCalled = false
    private(set) var countdownExpiredWasCalled = false
    
    func developerChanged(developer: Developer) {
        developerChangedWasCalled = true
    }
    
    func sessionStarted() {
        sessionStartedWasCalled = true
    }
    
    func sessionEnded() {
        sessionEndedWasCalled = true
    }
    
    func countdownExpired() {
        countdownExpiredWasCalled = true
    }
}
