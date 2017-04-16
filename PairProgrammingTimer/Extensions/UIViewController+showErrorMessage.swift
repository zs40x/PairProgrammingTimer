//
//  UIViewController+showErrorMessage.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 16.04.17.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showErrorMessage(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
