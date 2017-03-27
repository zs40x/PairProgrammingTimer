//
//  SecondsToHumanReadableDurationTests.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 02/02/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import XCTest
@testable import PairProgrammingTimer

class SecondsToHumanReadableDurationTests: XCTestCase {
    
    func testDisplaysZero() {
        
        XCTAssertEqual("00:00", runTest(seconds: 0))
    }
    
    func testDisplaysOneSecond() {
        
        XCTAssertEqual("00:01", runTest(seconds: 1))
    }
    
    func testDisplay15MinutesAnd30Seconds() {
        
        XCTAssertEqual("15:30", runTest(seconds: asSeconds(hours: 0, minutes: 15, seconds: 30)))
    }
    
    func testNegativeMinute() {
        
        XCTAssertEqual("-00:01", runTest(seconds: -1))
    }
    
    func testNegativeBeforeSecondsMinusIsPositive() {
        
        XCTAssertEqual("00:00", runTest(seconds: -0.9))
    }
    
    private func runTest(seconds: Double) -> String {
        return SecondsToHumanReadableDuration(seconds: seconds).humanReadableTime()
    }
    
    private func asSeconds(hours: Int, minutes: Int, seconds: Int = 0) -> Double{
        return Double((hours * 60 * 60) + (minutes * 60) + seconds)
    }
}
