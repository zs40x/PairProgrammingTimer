//
//  ProgrammingSessionTests_RemainingTime.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 31/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import XCTest
@testable import PairProgrammingTimer

class ProgrammingSessionTests_RemainingTime: ProgrammingSessionTests {
    
    func testTimeRemaingIsSessionDuration() {
        
        let startedSession = testInstance?.toggleState()
        
        XCTAssertEqual(15.0 * 60, startedSession?.timeRemaingInSeconds())
    }
    
    func testTimeRemaingTMinus10Minutes() {
        
        let startedSession = testInstance?.toggleState()
        
        fakeDateTime?.dateToReturn = startedOnDate.addingTimeInterval(5 * 60)
        
        XCTAssertEqual(10.0 * 60, startedSession?.timeRemaingInSeconds())
    }
    
    func testTimeRemainingTimerElapsedJustNow() {
        
        let startedSession = testInstance?.toggleState()
        
        fakeDateTime?.dateToReturn = startedOnDate.addingTimeInterval(sessionDuration.TotalMinutes * 60)
        
        XCTAssertEqual(0.0, startedSession?.timeRemaingInSeconds())
    }
    
    func testTimeRemaingTimerElapsed5MinutesAgo() {
        
        let startedSession = testInstance?.toggleState()
        
        fakeDateTime?.dateToReturn = startedOnDate.addingTimeInterval((sessionDuration.TotalMinutes + 5) * 60)
        
        XCTAssertEqual((5 * 60) * -1, startedSession?.timeRemaingInSeconds())
    }
    
    func testTimeRemaingAfterStopAndChangingDeveloperIsSessionDuration() {
        
        let startedSession = testInstance?.toggleState()
        
        fakeDateTime?.dateToReturn = startedOnDate.addingTimeInterval(60)
        let stoppedSession = startedSession?.toggleState()
        
        let changedDeveloperSession = stoppedSession?.changeDevelopers()
        
        XCTAssertEqual(sessionDuration.TotalMinutes * 60, changedDeveloperSession?.timeRemaingInSeconds())
    }
}
