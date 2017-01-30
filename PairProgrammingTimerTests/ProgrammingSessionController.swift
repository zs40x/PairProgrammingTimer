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
    var testInstance: ProgrammingSessionControl?
    var fakeSessionControlDelegate: FakeSessionControlDelegate?
    var fakeTimer: FakeTimer?
    var fakeDateTime: FakeDateTime?
    let startedOnDate = Date.init(timeIntervalSinceReferenceDate: 0.0) // January 1, 2001, at 12:00 a.m. GMT.
    
    override func setUp() {
        
        fakeTimer = FakeTimer()
        fakeDateTime = FakeDateTime(dateToReturn: startedOnDate)
        
        testInstance =
            ProgrammingSessionControl(
                timer: fakeTimer!,
                dateTime: fakeDateTime!,
                sessionDurationInMinutes: sessionDurationInMinutes)
        
        fakeSessionControlDelegate = FakeSessionControlDelegate()
        testInstance?.delegate = fakeSessionControlDelegate
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
    
    func testDelegateCalledWhenDeveloperWasChanged() {
        
        _ = testInstance?.changeDevelopers()
        
        XCTAssertEqual(true, fakeSessionControlDelegate?.developerChangedWasCalled)
    }
    
    func testDelegateCalledWhenSessionStarted() {
        
        _ = testInstance?.start()
        
        XCTAssertEqual(true, fakeSessionControlDelegate?.sessionStartedWasCalled)
    }
    
    func testDelegateCalledWhenSessionEnded() {
        
        testInstance?.stop()
        
        XCTAssertEqual(true, fakeSessionControlDelegate?.sessionEndedWasCalled)
    }
    
    func testDelegateCalledWhenTimerExpired() {
        
        // simulate that the timer expired after the countdown interval
        _ = testInstance?.start()
        fakeTimer?.expire()
        
        XCTAssertEqual(true, fakeSessionControlDelegate?.countdownExpiredWasCalled)
    }
    
    func testEndsOnExpectedDate() {
        
        let expectedEndDate = startedOnDate.addingTimeInterval(sessionDurationInMinutes * 60)
        
        XCTAssertEqual(expectedEndDate, testInstance?.start().sessionEndsOn)
    }
    
    func testTimeRemaingIsSessionDuration() {
        
        let startedSession = testInstance?.start()
        
        XCTAssertEqual(15.0 * 60, startedSession?.timeRemaingInSeconds())
    }
    
    func testTimeRemaingTMinus10Minutes() {
        
        let startedSession = testInstance?.start()
        
        fakeDateTime?.dateToReturn = startedOnDate.addingTimeInterval(5 * 60)
        
        XCTAssertEqual(10.0 * 60, startedSession?.timeRemaingInSeconds())
    }
}
  
