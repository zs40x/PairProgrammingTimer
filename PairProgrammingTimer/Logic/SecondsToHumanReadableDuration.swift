//
//  SecondsToUITime.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 02/02/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

class SecondsToHumanReadableDuration {
    
    let seconds: Double
    
    init(seconds: Double) {
        self.seconds = seconds
    }
    
    public func humanReadableTime() -> String {
        
        let seconds = secondsForCalculation()
        
        let displayMinutes = Int(seconds / 60)
        let displaySeconds = Int(seconds.truncatingRemainder(dividingBy: 60))
        
        return String(format:"%@%02i:%02i", isNegative() ? "-" : "",  displayMinutes, displaySeconds)
    }
    
    private func secondsForCalculation() -> Double {
        return seconds < 0 ? seconds * -1 : seconds
    }
    
    private func isNegative() -> Bool {
        return seconds <= -1
    }
}
