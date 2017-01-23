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
        
        testInstance = ProgrammingSessionControl()
    }

    func testIsInitializedWithLeftDeveloper() {
        
        XCTAssertEqual(Developer.left, testInstance?.session.developer)
    }
    
}
  
