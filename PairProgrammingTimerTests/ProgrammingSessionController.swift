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
    
    var testInstance: ProgrammingSessionControl?
    var fakeSessionControlDelegate: FakeSessionControlDelegate?
    var fakeTimer: FakeTimer?
    
    override func setUp() {
        
        fakeTimer = FakeTimer()
        
        testInstance = ProgrammingSessionControl(timer: fakeTimer!)
        
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
        
        testInstance?.start()
        
        XCTAssertEqual(true, fakeSessionControlDelegate?.sessionStartedWasCalled)
    }
    
    func testDelegateCalledWhenSessionEnded() {
        
        testInstance?.stop()
        
        XCTAssertEqual(true, fakeSessionControlDelegate?.sessionEndedWasCalled)
    }
    
    func testDelegateCalledWhenTimerExpired() {
        
        // simulate that the timer expired after the countdown interval
        testInstance?.start()
        fakeTimer?.expire()
        
        XCTAssertEqual(true, fakeSessionControlDelegate?.countdownExpiredWasCalled)
    }
}
  
