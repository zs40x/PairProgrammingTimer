//
//  ViewController.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 16/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let activeOffset: CGFloat = 5
    private let inactiveOffset: CGFloat = 20

    @IBOutlet weak var leftImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftImageTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftImageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightImageTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightImageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightImageTopConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftImageTopConstraint.constant = activeOffset
        leftImageBottomConstraint.constant = activeOffset
        leftImageLeadingConstraint.constant = activeOffset
        leftImageTrailingConstraint.constant = activeOffset
        
        rightImageTopConstraint.constant = inactiveOffset
        rightImageBottomConstraint.constant = inactiveOffset
        rightImageLeadingConstraint.constant = inactiveOffset
        rightImageTrailingConstraint.constant = inactiveOffset
        
    }

}

