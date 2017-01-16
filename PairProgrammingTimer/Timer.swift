//
//  Timer.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 16/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

protocol TimerExpiredDelegate {
    func timerExpired()
}

protocol Timer {
    func start(_ durationInSeconds: Double, callDelegateWhenExpired: TimerExpiredDelegate)
    func stop()
}

class SystemTimer: Timer {
    
    private var timer = Foundation.Timer()
    private var expiredDelegate: TimerExpiredDelegate?
    
    func start(_ durationInSeconds: Double, callDelegateWhenExpired: TimerExpiredDelegate) {
        
        expiredDelegate = callDelegateWhenExpired
        
        NSLog("SystemTimer.start(\(durationInSeconds), callback)")
        
        timer.invalidate()
        
        timer =
            Foundation.Timer.scheduledTimer(timeInterval: durationInSeconds, target: self, selector: #selector(SystemTimer.timerExpired), userInfo: nil, repeats: false)
    }
    
    func stop() {
        
        NSLog("SystemTimer.stop()")
        
        timer.invalidate()
    }
    
    @objc func timerExpired() {
        
        NSLog("SystemTimer.timerExpired()")
        
        guard let delegate = expiredDelegate else { return }
        
        delegate.timerExpired()
    }
}
