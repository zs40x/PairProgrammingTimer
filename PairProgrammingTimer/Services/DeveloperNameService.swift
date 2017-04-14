//
//  DeveloperNameService.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 14.04.17.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation

protocol DeveloperNameService {
    func nameOf(developer: Developer) -> String
}

class DeveloperNameAppSettingsService: DeveloperNameService {

    func nameOf(developer: Developer) -> String {
        
        let appSettings = AppSettings()
        
        return developer == .left ? appSettings.developerNames.left : appSettings.developerNames.right
    }
}
