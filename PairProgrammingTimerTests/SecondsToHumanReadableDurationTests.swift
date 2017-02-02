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
    
    private func runTest(seconds: Double) -> String {
        return SecondsToHumanReadableDuration(seconds: seconds).humanReadableTime()
    }
}
