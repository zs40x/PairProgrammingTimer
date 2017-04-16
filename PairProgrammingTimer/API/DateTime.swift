//
//  DateTime.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 28/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

protocol DateTime {
    func currentDateTime() -> Date
}

class SystemDateTime: DateTime {
    func currentDateTime() -> Date {
        return Date()
    }
}
