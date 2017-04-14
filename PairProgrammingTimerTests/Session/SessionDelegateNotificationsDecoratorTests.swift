//
//  SessionDelegateNotificationsDecoratorTests.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 17/03/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

import XCTest
@testable import PairProgrammingTimer

class SessionDelegateNotificationDecoratorTests: XCTestCase {
    
    var otherSessionDelegate: FakeSessionDelegate?
    var fakeNotifications: FakeNotifications?
    var testInstance: SessionDelegateNotificationDecorator?
    
    override func setUp() {
       
        otherSessionDelegate = FakeSessionDelegate()
        fakeNotifications = FakeNotifications()
        
        testInstance =
            SessionDelegateNotificationDecorator(
                other: otherSessionDelegate!,
                notifications: fakeNotifications!,
                developerNameService: FakeDeveloperNameService())
    }
    
    
    func testNothingHappened() {
        
        XCTAssert(!fakeNotifications!.registered)
        XCTAssert(!fakeNotifications!.pendingCancelled)
    }
    
    func testDeveloperChanged() {
        testInstance?.developerChanged(developer: Developer.left)
        
        XCTAssert(otherSessionDelegate!.developerChangedWasCalled)
    }
    
    func testSessionStarted() {
        
        testInstance?.sessionStarted(sessionEndsOn: Date(), forDeveloper: .left, restored: false)
        
        XCTAssert(fakeNotifications!.registered)
        XCTAssert(!fakeNotifications!.pendingCancelled)
        
        XCTAssert(otherSessionDelegate!.sessionStartedWasCalled)
    }
    
    func testSessionEnded() {
        
        testInstance?.sessionEnded(forDeveloper: .left)
        
        XCTAssert(!fakeNotifications!.registered)
        XCTAssert(fakeNotifications!.pendingCancelled)
        
        XCTAssert(otherSessionDelegate!.sessionEndedWasCalled)

    }
    
    func testCountdownExpired() {
        
        testInstance?.countdownExpired()
        
        XCTAssert(otherSessionDelegate!.countdownExpiredWasCalled)
    }
}

