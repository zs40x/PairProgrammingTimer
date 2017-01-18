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

enum CurrentState: Int {
    case idle = 0
    case active
}

class ViewController: UIViewController {
    
    private let activeOffset: CGFloat = 5
    private let inactiveOffset: CGFloat = 25
    
    fileprivate let timer = SystemTimer()
    private var timerElapsesOnDate: Date?
    private var activeDeveloper: Developer = .left
    fileprivate var currentState: CurrentState = .idle
    
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
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var labelTimer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateImageOffsets()
    }

    @IBAction func actionFlipDeveloper(_ sender: Any) {
        activeDeveloper = (activeDeveloper == .left ? .right : .left)
        updateImageOffsets()
        updateDeveloperImages()
    }
    
    @IBAction func actionStart(_ sender: Any) {
        currentState = currentState == .idle ? .active : .idle
        
        if currentState == .active {
            timerElapsesOnDate = Date().addingTimeInterval(15 * 60)
            timer.start(0.25, callDelegateWhenExpired: self)
        }
        
        updateCurrentState()
    }
    
    private func updateCurrentState() {
        
        let newImage = currentState == .active ? UIImage(named: "play-100")! : UIImage(named: "pause_100")!
       
        buttonStart.setImage(newImage, for: .normal)
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
    
    fileprivate func updateTimer() {
        
        guard let timerElapsesOnDate = timerElapsesOnDate else { return }
        
        let interval = DateInterval(start: Date(), end: timerElapsesOnDate)
        
        let minutes = Int(interval.duration) / 60 % 60
        let seconds = Int(interval.duration) % 60
        
        labelTimer.text = String(format:"%02i:%02i", minutes, seconds)
    }
}

extension ViewController: TimerExpiredDelegate {
    
    func timerExpired() {
        
        updateTimer()
        
        if currentState == .active {
            timer.start(0.25, callDelegateWhenExpired: self)
        }
    }
}

