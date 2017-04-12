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
        
        sessionLog = SessionLog(dateTime: fakeDateTime!)
        
        programingSession =
            ProgrammingSession(
                withDeveloper: .left,
                delegate: SessionDelegateLogDecorator(other: fakeSessionDelegate!, log: sessionLog!),
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
    }
    
    func testChangedDeveloperSessionLogEntries() {
        
        programingSession = programingSession?.toggleState().changeDevelopers()
        
        XCTAssertEqual(2, sessionLog?.entries.count)
        
        XCTAssertEqual(fakeDateTime?.currentDateTime(), sessionLog?.entries.first?.startedOn)
        XCTAssertEqual(fakeDateTime?.currentDateTime(), sessionLog?.entries.first?.endedOn)

    }
}
