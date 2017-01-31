//
//  ProgrammingSessionController.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 23/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import XCTest
@testable import PairProgrammingTimer

class ProgrammingSessionControllerTests: XCTestCase {
    
    let sessionDurationInMinutes = 15.0
    var testInstance: ProgrammingSession?
    var fakeSessionDelegate: FakeSessionDelegate?
    var fakeTimer: FakeTimer?
    var fakeDateTime: FakeDateTime?
    let startedOnDate = Date.init(timeIntervalSinceReferenceDate: 0.0) // January 1, 2001, at 12:00 a.m. GMT.
    
    override func setUp() {
        
        fakeTimer = FakeTimer()
        fakeDateTime = FakeDateTime(dateToReturn: startedOnDate)
        fakeSessionDelegate = FakeSessionDelegate()
        
        testInstance =
            ProgrammingSession(
                delegate: fakeSessionDelegate!,
                timer: fakeTimer!,
                dateTime: fakeDateTime!,
                sessionDurationInMinutes: sessionDurationInMinutes)
    }

    func testIsInitializedWithLeftDeveloper() {
        
        XCTAssertEqual(Developer.left, testInstance?.developer)
    }
    
    func testChangeDeveloperChangesSessionToRight() {
        
        XCTAssertEqual(Developer.right, testInstance?.changeDevelopers().developer)
    }
    
    func testChangeDevelopers2TimesChangesBackToLeft() {
        
        XCTAssertEqual(Developer.left, testInstance?.changeDevelopers().changeDevelopers().developer)
    }
    
    func testStartedStoppedSession() {
        
        let stoppedSession = testInstance?.toggleState().toggleState()
        
        XCTAssertEqual(SessionState.idle, stoppedSession?.sessionState)
    }
    
    func testStartedStoppedAndRestartedSession() {
        
        let restartedSession = testInstance?.toggleState().toggleState().toggleState()
        
        XCTAssertEqual(SessionState.active, restartedSession?.sessionState)
    }
    
    func testDelegateCalledWhenDeveloperWasChanged() {
        
        _ = testInstance?.changeDevelopers()
        
        XCTAssertEqual(true, fakeSessionDelegate?.developerChangedWasCalled)
    }
    
    func testDelegateCalledWhenSessionStarted() {
        
        _ = testInstance?.toggleState()
        
        XCTAssertEqual(true, fakeSessionDelegate?.sessionStartedWasCalled)
    }
    
    func testDelegateCalledWhenSessionEnded() {
        
        _ = testInstance?.toggleState().toggleState()
        
        XCTAssertEqual(true, fakeSessionDelegate?.sessionEndedWasCalled)
    }
    
    func testDelegateCalledWhenTimerExpired() {
        
        // simulate that the timer expired after the countdown interval
        _ = testInstance?.toggleState()
        fakeTimer?.expire()
        
        XCTAssertEqual(true, fakeSessionDelegate?.countdownExpiredWasCalled)
    }
    
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
        
        fakeDateTime?.dateToReturn = startedOnDate.addingTimeInterval(sessionDurationInMinutes * 60)
        
        XCTAssertEqual(0.0, startedSession?.timeRemaingInSeconds())
    }
    
    func testTimeRemaingTimerElapsed5MinutesAgo() {
        
        let startedSession = testInstance?.toggleState()
        
        fakeDateTime?.dateToReturn = startedOnDate.addingTimeInterval((sessionDurationInMinutes + 5) * 60)
        
        XCTAssertEqual((5 * 60) * -1, startedSession?.timeRemaingInSeconds())
    }
    
    func testTimeRemaingAfterStopAndChangingDeveloperIsSessionDuration() {
        
        let startedSession = testInstance?.toggleState()
        
        fakeDateTime?.dateToReturn = startedOnDate.addingTimeInterval(60)
        let stoppedSession = startedSession?.toggleState()
        
        let changedDeveloperSession = stoppedSession?.changeDevelopers()
        
        XCTAssertEqual(sessionDurationInMinutes * 60, changedDeveloperSession?.timeRemaingInSeconds())
    }
}
  
