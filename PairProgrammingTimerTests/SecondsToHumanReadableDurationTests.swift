//
//  SecondsToHumanReadableDurationTests.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 02/02/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import XCTest
@testable import PairProgrammingTimer

class SecondsToHumanReadableDurationTests: XCTest {
    
    func testDisplayZero() {
        
        XCTAssertEqual("00:00", runTest(seconds: 0))
    }
    
    private func runTest(seconds: Double) -> String {
        return SecondsToHumanReadableDuration(seconds: seconds).humanReadableTime()
    }
}
