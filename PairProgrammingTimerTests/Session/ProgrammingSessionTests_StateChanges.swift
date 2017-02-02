//
//  ProgrammingSessionTests_StateChanges.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 31/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import XCTest
@testable import PairProgrammingTimer

class ProgrammingSessionStateChangesTests: ProgrammingSessionTests {
    
    func testIsInitializedWithLeftDeveloper() {
        
        XCTAssertEqual(Developer.left, testInstance?.developer)
    }
    
    func testChangeDeveloperChangesSessionToRight() {
        
        XCTAssertEqual(Developer.right, testInstance?.changeDevelopers().developer)
    }
    
    func testChangeDevelopers2TimesChangesBackToLeft() {
        
        XCTAssertEqual(Developer.left, testInstance?.changeDevelopers().changeDevelopers().developer)
    }
    
    func testChangeDevelopersStateStillIdle() {
        
        XCTAssertEqual(SessionState.idle, testInstance?.changeDevelopers().sessionState)
    }
    
    func testChangeDevelopersInRunningSessionAutostartsNextSession() {
        
        let startedSession = testInstance?.toggleState()
        
        XCTAssertEqual(SessionState.active, startedSession?.changeDevelopers().sessionState)
    }
    
    func testStartedStoppedSession() {
        
        let stoppedSession = testInstance?.toggleState().toggleState()
        
        XCTAssertEqual(SessionState.idle, stoppedSession?.sessionState)
    }
    
    func testTimerIsStoppedWithSession() {
        
        _ = testInstance?.toggleState().toggleState()
        
        XCTAssertTrue((fakeTimer?.stopCalled)!)
    }
    
    func testStartedStoppedAndRestartedSession() {
        
        let restartedSession = testInstance?.toggleState().toggleState().toggleState()
        
        XCTAssertEqual(SessionState.active, restartedSession?.sessionState)
    }
}
