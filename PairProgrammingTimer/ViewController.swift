//
//  ViewController.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 16/01/2017.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

class ViewController: UIViewController {
    
    private let activeOffset: CGFloat = 5
    private let inactiveOffset: CGFloat = 25
    private var disableNotificationWarningShown = false
    
    fileprivate let appSettings = AppSettings()
    fileprivate var sessionControl: Session?
    fileprivate let updateTimer = SystemTimer(durationInSeconds: 0.25, repeatWhenExpired: true)
    
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
        
        let sessionDuration = appSettings.SessionDuration()
        
        sessionControl =
            ProgrammingSession(
                withDeveloper: appSettings.CurrentDeveloper(),
                delegate: SessionDelegateNotificationDecorator(other: self, notifications: LocalNotifications(timeInterval: sessionDuration.TotalSeconds)),
                timer: SystemTimer(durationInSeconds: sessionDuration.TotalSeconds, repeatWhenExpired: false),
                dateTime: SystemDateTime(),
                sessionDurationInMinutes: sessionDuration.TotalMinutes)
        
        updateUserInterface(developer: sessionControl!.developer)
        
        initializeNotifications()
    }

    @IBAction func actionFlipDeveloper(_ sender: Any) {
        
        sessionControl = sessionControl?.changeDevelopers()
    }
    
    @IBAction func actionStart(_ sender: Any) {
        
        if     !AppDelegate.current().localNotificationsEnabled
            && sessionControl?.sessionState == .idle
            && !disableNotificationWarningShown {
            let alert =
                UIAlertController(
                    title: "Notifications disabled",
                    message: "To recreive notifications when the app is not in the foreground enable them in the system settings.",
                    preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil ))
            self.present(alert, animated: true, completion: nil)
            
            disableNotificationWarningShown = true
        }
        
        sessionControl = sessionControl?.toggleState()
    }
    
    fileprivate func updateCurrentState(sessionState: SessionState) {
        
        let newImage = sessionState == .active ? UIImage(named: "stop-100")! : UIImage(named: "play-100")!
       
        buttonStart.setImage(newImage, for: .normal)
    }
    
    fileprivate func updateUserInterface(developer: Developer) {
        
        updateRemainingTime()
        updateImageOffsets(activeDeveloper: developer)
        updateDeveloperImages(activeDeveloper: developer)
        
    }
    
    private func updateDeveloperImages(activeDeveloper: Developer) {
        rightDeveloperImageView.image = developerStateImage(isActive: activeDeveloper == .right)
        leftDeveloperImageView.image = developerStateImage(isActive: activeDeveloper == .left)
    }
    
    private func developerStateImage(isActive: Bool) -> UIImage {
        return isActive ? UIImage(named: "man_filled_100")! : UIImage(named: "man_100")!
    }
    
    private func updateImageOffsets(activeDeveloper: Developer) {
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
        
        guard let remainingSeconds = sessionControl?.timeRemaingInSeconds() else { return }
        
        labelTimer.text = SecondsToHumanReadableDuration(seconds: remainingSeconds).humanReadableTime()
    }
    
    private func initializeNotifications() {
        
        UNUserNotificationCenter.current().delegate = self
        
        let actionStop = UNNotificationAction(identifier: Notification.Action.stopSession, title: "Stop session", options: [])
        let actionChangeDeveloper = UNNotificationAction(identifier: Notification.Action.changeDeveloper, title: "Change developer", options: [])
        
        let stopSessionCategory =
            UNNotificationCategory(identifier: Notification.Category.sessionExpired, actions: [actionStop, actionChangeDeveloper], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([stopSessionCategory])
    }
}

extension ViewController: CountdownTimerExpiredDelegate {
    
    func timerExpired() {
        
        updateRemainingTime()
    }
}

extension ViewController: SessionDelegate {
    
    func developerChanged(developer: Developer) {
     
        updateUserInterface(developer: developer)
        
        appSettings.SaveCurrentDeveloper(developer)
    }
    
    func sessionStarted() {
        
        labelTimer.layer.removeAllAnimations()
        updateCurrentState(sessionState: .active)
        updateTimer.start(callDelegateWhenExpired: self)
    }
    
    func sessionEnded() {
         
        labelTimer.layer.removeAllAnimations()
        updateCurrentState(sessionState: .idle)
        
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

extension ViewController : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        NSLog("userNotificationCenter.didReceive: \(response.actionIdentifier)")
        
        if sessionControl?.sessionState == SessionState.idle {
            NSLog("Igoring action, session idle")
            return
        }
        
        switch response.actionIdentifier {
        case Notification.Action.stopSession:
            sessionControl = sessionControl?.toggleState()
        case Notification.Action.changeDeveloper:
            sessionControl = sessionControl?.changeDevelopers()
        default:
            NSLog("Invalid actionIdentifier: \(response.actionIdentifier)")
        }
        
        completionHandler()
    }
}
