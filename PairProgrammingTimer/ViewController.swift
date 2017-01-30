//
//  ViewController.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 16/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import UIKit
import AVFoundation

enum Developer: Int {
    case left = 0
    case right
}

enum CurrentState: Int {
    case idle = 0
    case active
}

class ViewController: UIViewController {
    
    private static let countDownMinutes: Double = 15
    private let activeOffset: CGFloat = 5
    private let inactiveOffset: CGFloat = 25
    
    fileprivate var sessionControl: SessionControl =
        ProgrammingSessionControl(
            timer: SystemTimer(durationInSeconds: 15 * 60, repeatWhenExpired: false),
            dateTime: SystemDateTime(),
            sessionDurationInMinutes: countDownMinutes)
    
    fileprivate let updateTimer = SystemTimer(durationInSeconds: 0.5, repeatWhenExpired: true)
    
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
        sessionControl.delegate = self
        updateImageOffsets(activeDeveloper: .left)
    }

    @IBAction func actionFlipDeveloper(_ sender: Any) {
        
        sessionControl = sessionControl.changeDevelopers()
        sessionControl.delegate = self
    }
    
    @IBAction func actionStart(_ sender: Any) {
        
        sessionControl = sessionControl.start()
    }
    
    fileprivate func updateCurrentState(_ currentState: CurrentState) {
        
        let newImage = currentState == .active ? UIImage(named: "pause_100")! : UIImage(named: "play-100")!
       
        buttonStart.setImage(newImage, for: .normal)
    }
    
    fileprivate func updateDeveloperImages(activeDeveloper: Developer) {
        rightDeveloperImageView.image = developerStateImage(isActive: activeDeveloper == .right)
        leftDeveloperImageView.image = developerStateImage(isActive: activeDeveloper == .left)
    }
    
    private func developerStateImage(isActive: Bool) -> UIImage {
        return isActive ? UIImage(named: "man_filled_100")! : UIImage(named: "man_100")!
    }
    
    fileprivate func updateImageOffsets(activeDeveloper: Developer) {
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
    
    fileprivate func updateRemainingTime() {
        
        var isNegative = false
        var duration = sessionControl.timeRemaingInSeconds()
        
        if duration < 0 {
            duration = duration * -1
            isNegative = true
        }
        
        let minutes = Int(duration) / 60 % 60
        let seconds = Int(duration) % 60
        
        labelTimer.text = String(format:"%@%02i:%02i", isNegative ? "-" : "", minutes, seconds)
    }
}

extension ViewController: CountdownTimerExpiredDelegate {
    
    func timerExpired() {
        
        updateRemainingTime()
    }
}

extension ViewController: SessionControlDelegate {
    
    func developerChanged(developer: Developer) {
     
        updateImageOffsets(activeDeveloper: developer)
        updateDeveloperImages(activeDeveloper: developer)
    }
    
    func sessionStarted() {
        updateCurrentState(.active)
        
        updateTimer.start(callDelegateWhenExpired: self)
    }
    
    func sessionEnded() {
        labelTimer.layer.removeAllAnimations()
        updateCurrentState(.idle)
        
        updateTimer.stop()
    }
    
    func countdownExpired() {
        
        DispatchQueue.main.async {
            AudioServicesPlaySystemSound(1006)
            
            UIView.animate(
                withDuration: 1.2,
                delay: 0.0,
                options: [.curveEaseInOut, .autoreverse, .repeat],
                animations: { [weak self] in self?.labelTimer.alpha = 0.0 },
                completion: { [weak self] _ in self?.labelTimer.alpha = 1.0 })
        }
    }
}
