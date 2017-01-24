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
    
    override func setUp() {
        
        testInstance = ProgrammingSessionControl(timer: FakeTimer())
    }

    func testIsInitializedWithLeftDeveloper() {
        
        XCTAssertEqual(Developer.left, testInstance?.session.developer)
    }
    
    func testChangeDeveloperChangesSessionToRight() {
        
        XCTAssertEqual(Developer.right, testInstance?.changeDevelopers().session.developer)
    }
    
    func testChangeDevelopers2TimesChangesBackToLeft() {
        
        XCTAssertEqual(Developer.left, testInstance?.changeDevelopers().changeDevelopers().session.developer)
    }
    
}
  
