//
//  FakeDateTime.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 30/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation
@testable import PairProgrammingTimer

class FakeDateTime: DateTime {
    
    var dateToReturn: Date
    
    init(dateToReturn: Date) {
        self.dateToReturn = dateToReturn
    }
    
    func currentDateTime() -> Date {
        return dateToReturn
    }
}
