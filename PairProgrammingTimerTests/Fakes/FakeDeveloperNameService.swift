//
//  FakeDeveloperNameService.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 14.04.17.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation
@testable import PairProgrammingTimer

class FakeDeveloperNameService: DeveloperNameService {
    
    func nameOf(developer: Developer) -> String {
        return String(developer.rawValue)
    }
}
