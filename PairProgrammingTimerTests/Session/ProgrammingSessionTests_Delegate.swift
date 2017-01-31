//
//  ProgrammingSessionTests_Delegate.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 31/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import XCTest
@testable import PairProgrammingTimer

class ProgrammingSessionDelegateTests: ProgrammingSessionTests {
    
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
}
