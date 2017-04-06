//
//  SessionDuration.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 30/03/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

struct SessionDuration {
    let TotalMinutes: Double
    let TotalSeconds: Double
    
    init(minutes: Int) {
        self.TotalMinutes = Double(minutes)
        self.TotalSeconds = Double(minutes * 60)
    }
}

extension SessionDuration: Equatable {}

func ==(lhs: SessionDuration, rhs: SessionDuration) -> Bool {
    return lhs.TotalSeconds == rhs.TotalSeconds
}
