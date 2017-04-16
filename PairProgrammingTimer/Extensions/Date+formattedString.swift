//
//  Date+formattedString.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 16.04.17.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

enum CustomDateTimeFormat: Int {
    case dateAndTime = 0
    case timeOnly
}

extension Date {
    
    func formattedString(customDateFormat: CustomDateTimeFormat) -> String {
        
        return configuredDateFormatter(customDateFormat).string(from: self)
    }
    
    func configuredDateFormatter(_ customDateTimeFormat: CustomDateTimeFormat) -> DateFormatter {
        
        let dateFormatter = DateFormatter()
        
        switch customDateTimeFormat {
        case .dateAndTime:
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
        case .timeOnly:
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .medium
        }
        
        return dateFormatter
    }
}
