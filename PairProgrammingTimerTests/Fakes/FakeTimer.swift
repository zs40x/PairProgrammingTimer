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
    
    var stopCalled = false
    private var delegate: CountdownTimerExpiredDelegate?
    
    func start(callDelegateWhenExpired: CountdownTimerExpiredDelegate) {
        delegate = callDelegateWhenExpired
    }
    
    func stop() {
        stopCalled = false
    }
    
    func expire() {
        delegate?.timerExpired()
    }
}
