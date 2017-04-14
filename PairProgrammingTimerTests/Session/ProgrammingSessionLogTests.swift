//
//  ProgrammingSessionLogTests.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 12.04.17.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import XCTest
@testable import PairProgrammingTimer

class ProgrammingSessionLogTests: ProgrammingSessionTests {
    
    var programingSession: Session?
    var sessionLog: SessionLog?
    
    override func setUp() {
        super.setUp()
        
        sessionLog = SessionLog(dateTime: fakeDateTime!, sessionLogService: FakeSessionLogService())
        
        programingSession =
            ProgrammingSession(
                withDeveloper: .left,
                delegate: SessionDelegateLogDecorator(other: fakeSessionDelegate!, log: sessionLog!, developerNameService: FakeDeveloperNameService()),
                timer: fakeTimer!,
                dateTime: fakeDateTime!,
                sessionDuration: SessionDuration(minutes: Int(sessionDurationInMinutes)))
    }
    
    func testStartedSessionLogEntry() {
        
        programingSession = programingSession?.toggleState()
        
        XCTAssertEqual(1, sessionLog?.entries.count)
        
        XCTAssertEqual(fakeDateTime?.currentDateTime(), sessionLog?.entries.first?.startedOn)
    }
    
    func testStoppedSessionLogEntry() {
        
        programingSession = programingSession?.toggleState().toggleState()
        
        XCTAssertEqual(1, sessionLog?.entries.count)
        
        XCTAssertEqual(fakeDateTime?.currentDateTime(), sessionLog?.entries.first?.endedOn)
        
        XCTAssertEqual(leftDeveloperName, sessionLog?.entries.first?.developerName)
        XCTAssertEqual(rightDeveloperName, sessionLog?.entries.first?.otherDeveloperName)
    }
    
    func testChangedDeveloperSessionLogEntries() {
        
        programingSession = programingSession?.toggleState().changeDevelopers()
        
        XCTAssertEqual(2, sessionLog?.entries.count)
        
        XCTAssertEqual(fakeDateTime?.currentDateTime(), sessionLog?.entries.first?.startedOn)
        XCTAssertEqual(fakeDateTime?.currentDateTime(), sessionLog?.entries.first?.endedOn)
        
        XCTAssertEqual(leftDeveloperName, sessionLog?.entries.first?.developerName)
        XCTAssertEqual(rightDeveloperName, sessionLog?.entries.first?.otherDeveloperName)
        
        XCTAssertEqual(rightDeveloperName, sessionLog?.entries.last?.developerName)
        XCTAssertEqual(leftDeveloperName, sessionLog?.entries.last?.otherDeveloperName)
    }
    
    func testRestoredSessionDoesNotCreateANewLogEntry() {
        
        programingSession = programingSession?.restoreState(sessionState: .active, sessionEndsOn: Date())
        
        XCTAssertEqual(0, sessionLog?.entries.count)
    }
}
