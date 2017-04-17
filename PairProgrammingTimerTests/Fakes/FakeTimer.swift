//
//  FakeTimer.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 24/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation
@testable import PairProgrammingTimer

class FakeTimer: CountdownTimer {
    
    private(set) var stopCalled = false
    private(set) var startedWithDurationInSeconds: Double = 0
    private var delegate: CountdownTimerExpiredDelegate?
    
    func start(durationInSeconds: Double, callDelegateWhenExpired: CountdownTimerExpiredDelegate) {
        delegate = callDelegateWhenExpired
        startedWithDurationInSeconds = durationInSeconds
    }
    
    func stop() {
        stopCalled = true
    }
    
    func expire() {
        delegate?.timerExpired()
    }
}
