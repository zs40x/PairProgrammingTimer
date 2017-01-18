//
//  ViewController.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 16/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import UIKit

enum Developer: Int {
    case left = 0
    case right
}

class ViewController: UIViewController {
    
    private let activeOffset: CGFloat = 5
    private let inactiveOffset: CGFloat = 25
    
    private let timer = SystemTimer()
    private var activeDeveloper: Developer = .left
    
    @IBOutlet weak var leftDeveloperImageView: UIImageView!
    @IBOutlet weak var rightDeveloperImageView: UIImageView!
    @IBOutlet weak var leftImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftImageTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftImageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightImageTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightImageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonPause: UIButton!
    @IBOutlet weak var buttonStart: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateImageOffsets()
    }

    @IBAction func actionFlipDeveloper(_ sender: Any) {
        activeDeveloper = (activeDeveloper == .left ? .right : .left)
        updateImageOffsets()
        updateDeveloperImages()
    }
    
    @IBAction func actionPause(_ sender: Any) {
    }
    
    @IBAction func actionStart(_ sender: Any) {
    }
    
    private func updateDeveloperImages() {
        rightDeveloperImageView.image = developerStateImage(isActive: activeDeveloper == .right)
        leftDeveloperImageView.image = developerStateImage(isActive: activeDeveloper == .left)
    }
    
    private func developerStateImage(isActive: Bool) -> UIImage {
        return isActive ? UIImage(named: "man_filled_100")! : UIImage(named: "man_100")!
    }
    
    private func updateImageOffsets() {
        updateLeftDeveloperOffset(offset: (activeDeveloper == .left ? activeOffset : inactiveOffset))
        updateRightDeveloperOffset(offset: (activeDeveloper == .right ? activeOffset : inactiveOffset))
    }
    
    private func updateLeftDeveloperOffset(offset: CGFloat) {
        leftImageTopConstraint.constant = offset
        leftImageBottomConstraint.constant = offset
        leftImageLeadingConstraint.constant = offset
        leftImageTrailingConstraint.constant = offset
    }
    
    private func updateRightDeveloperOffset(offset: CGFloat) {
        rightImageTopConstraint.constant = offset
        rightImageBottomConstraint.constant = offset
        rightImageLeadingConstraint.constant = offset
        rightImageTrailingConstraint.constant = offset
    }
}

