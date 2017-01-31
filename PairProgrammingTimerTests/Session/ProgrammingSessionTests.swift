//
//  ProgrammingSessionController.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 23/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import XCTest
@testable import PairProgrammingTimer

class ProgrammingSessionTests: XCTestCase {
    
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
}
  
