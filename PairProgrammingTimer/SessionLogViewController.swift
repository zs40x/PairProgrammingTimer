//
//  SessionLogViewController.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 11.04.17.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import UIKit
import MessageUI

class SessionLogEntryCell : UITableViewCell {
    @IBOutlet weak var developerName: UILabel!
    @IBOutlet weak var otherDeveloperName: UILabel!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var until: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var sessionDuration: UILabel!
    @IBOutlet weak var sessionDurationDifference: UILabel!
}

class SessionLogViewController: UIViewController, SessionLogConsumer {
    
    @IBOutlet weak var tableViewLogEntries: UITableView!
    @IBOutlet weak var menuButtonSendAsMail: UIBarButtonItem!
    
    var sessionLog: SessionLog?
    
    fileprivate var logEntries = [SessionLogEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewLogEntries.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        updateTableView()
        
        guard MFMessageComposeViewController.canSendAttachments() else {
            NSLog("Cannot send mails with attachments")
            menuButtonSendAsMail.isEnabled = false
            return
        }
    }
    
    fileprivate func updateTableView() {
        
        guard let sessionLog = self.sessionLog else { return }
        
        logEntries =
            sessionLog.entries.sorted(by: { $0.startedOn > $1.startedOn })
        
        tableViewLogEntries.reloadData()
    }
    
    @IBAction func actionClearLog(_ sender: Any) {
        
        let alertView =
            UIAlertController(
                title: NSLocalizedString("ClearLog", comment: "Clear log"),
                message: NSLocalizedString("InfoAllLogEntriesWillBeDeleted", comment: "All log entries will be deleted!"),
                preferredStyle: .actionSheet)
        
        let confirmAction =
            UIAlertAction(title: NSLocalizedString("Confirm", comment: "Confirm"),
                          style: .destructive,
                          handler: { _ in
                                self.sessionLog?.clear()
                                self.updateTableView()
                            })
        alertView.addAction(confirmAction)
        
        let abortAction =
            UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
        alertView.addAction(abortAction)
        
        present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func actionSendAsMail(_ sender: Any) {
    
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        
        let jsonStringArray = logEntries.map { $0.jsonRepresentation }
        
        guard let data = try? JSONSerialization.data(withJSONObject: jsonStringArray, options: []) else { return }
        
        mailComposer.setSubject("PairProgrammingTimer log")
        mailComposer.setMessageBody("The log is attached!", isHTML: false)
        mailComposer.addAttachmentData(data, mimeType: "text/json", fileName: "PairProgTimer.log.json")
        
        present(mailComposer, animated: true, completion: nil)
    }
}

extension SessionLogViewController: SessionLogDelegate {
    
    func logUpdated() {
        updateTableView()
    }
}

extension SessionLogViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logEntries.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "SessionLogEntryCell", for: indexPath) as! SessionLogEntryCell
        
        let logEntry = logEntries[(indexPath as NSIndexPath).row]
        cell.developerName.text = logEntry.developerName
        cell.otherDeveloperName.text = logEntry.otherDeveloperName
        
        let longDateFormatter = DateFormatter()
        longDateFormatter.dateFormat = "dd.MM.YYYY HH:mm:ss"
        cell.from.text = longDateFormatter.string(from: logEntry.startedOn)
        
        
        let shortDateFormatter = DateFormatter()
        shortDateFormatter.dateFormat = "HH:mm:ss"
        if let until = logEntry.endedOn {
            cell.until.text = shortDateFormatter.string(from: until)
        } else {
            cell.until.text = ""
        }
        
        cell.duration.text = String(format: "%.2f", logEntry.actualDuration)
        cell.sessionDuration.text = String(format: "%.0f", logEntry.plannedDuration.TotalMinutes)
        
        var durationDifference = String(format: "%0.2f", logEntry.durationDifference)
        if logEntry.durationDifference > 0 {
           durationDifference = "+\(durationDifference)"
        }
        cell.sessionDurationDifference.text = durationDifference
        
        return cell
    }
}

extension SessionLogViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}
