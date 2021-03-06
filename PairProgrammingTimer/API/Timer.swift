//
//  Timer.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 16/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

protocol CountdownTimerExpiredDelegate {
    func timerExpired()
}

protocol CountdownTimer {
    func start(durationInSeconds: Double, callDelegateWhenExpired: CountdownTimerExpiredDelegate)
    func stop()
}

class SystemTimer: CountdownTimer {
    
    private let repeatWhenExpired: Bool
    private var timer: Foundation.Timer?
    private var expiredDelegate: CountdownTimerExpiredDelegate?
    
    init(repeatWhenExpired: Bool) {
        self.repeatWhenExpired = repeatWhenExpired
    }
    
    func start(durationInSeconds: Double, callDelegateWhenExpired: CountdownTimerExpiredDelegate) {
        
        expiredDelegate = callDelegateWhenExpired
        
        NSLog("SystemTimer.start(\(durationInSeconds), callback)")
        
        timer?.invalidate()
        
        timer =
            Foundation.Timer.scheduledTimer(
                timeInterval: durationInSeconds,
                target: self,
                selector: #selector(SystemTimer.timerExpired),
                userInfo: nil,
                repeats: repeatWhenExpired)
    }
    
    func stop() {
        
        NSLog("SystemTimer.stop()")
        
        timer?.invalidate()
    }
    
    @objc func timerExpired() {
        
        guard let delegate = expiredDelegate else { return }
        
        delegate.timerExpired()
    }
}
