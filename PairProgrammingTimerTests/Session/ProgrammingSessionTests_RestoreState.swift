//
//  ProgrammingSessionTests_RestoreState.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 03.04.17.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation
import XCTest
@testable import PairProgrammingTimer

class ProgrammingSessionRestoreStateTests: ProgrammingSessionTests {
    
    func testIdleSessionReturnsUnmodified() {
        
        XCTAssertTrue(testInstance!.isEqualTo(otherSession: testInstance!.restoreState(sessionState: .idle, sessionEndsOn: Date())))
    }
    
    func testActiveSessionThatExpiresInTheFuture() {
        
        let endDateInTheFuture = startedOnDate.addingTimeInterval(5 * 60)
    
        let restoredSession = testInstance!.restoreState(sessionState: .active, sessionEndsOn: endDateInTheFuture) as! ProgrammingSession
        
        XCTAssertEqual(endDateInTheFuture, restoredSession.sessionEndsOn)
        XCTAssertEqual(SessionState.active, restoredSession.sessionState)
    }
    
    func testActiveSessionNotRestoredWhenItsTooOld() {
        
        let endDateInThePast = startedOnDate.addingTimeInterval((120 * 60) * -1)
        
        XCTAssertTrue(testInstance!.isEqualTo(otherSession: testInstance!.restoreState(sessionState: .active, sessionEndsOn: endDateInThePast)))
    }
    
    func testActiveSessionSetsTimerToTheRemainingTime() {
        
        let endDateInTheFuture = startedOnDate.addingTimeInterval((sessionDuration.TotalMinutes - 10.0) * 60)
        
        _ = testInstance?.restoreState(sessionState: .active, sessionEndsOn: endDateInTheFuture)
        
        // timer should be set only for the remaining 5 minutes
        XCTAssertEqual(fakeTimer?.startedWithDurationInSeconds, 5 * 60)
    }
    
    func testActiveExpiredSessionRestoredFiresTimerImmideatly() {
        
        let endDateInThePast = startedOnDate.addingTimeInterval((120 * 60) * -1)
        
        _ = testInstance?.restoreState(sessionState: .active, sessionEndsOn: endDateInThePast)
        
        XCTAssertEqual(fakeTimer?.startedWithDurationInSeconds, 0)
    }
}
