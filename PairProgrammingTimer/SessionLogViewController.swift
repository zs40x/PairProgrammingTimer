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
        
        do {
            let fileUrl = try SessionUserDefaultsLogService().exportToFileSystem()
            
            guard fileUrl != nil else {
                
                showErrorMessage(title: NSLocalizedString("SharingFailed", comment: "Sharing failed"),
                                message: NSLocalizedString("ExportFailedMsg", comment: "Failed to export: detailed error"))
                return
            }
            
            let activityViewController = UIActivityViewController(
                activityItems:
                    [NSLocalizedString("ShareMessage", comment: "Message to show when sharing an exported file."),
                                        fileUrl as Any!],
                applicationActivities: nil)
            
            if let popoverPresentationController = activityViewController.popoverPresentationController {
                popoverPresentationController.barButtonItem = (sender as! UIBarButtonItem)
            }
            
            present(activityViewController, animated: true, completion: nil)
            
        } catch let error {
            showErrorMessage(title: NSLocalizedString("SharingFailed", comment: "Sharing failed"),
                             message: error.localizedDescription)
            NSLog("Error sharing the PairProgTimer.log file: \(error.localizedDescription)")
            return
        }
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
        
        cell.from.text = logEntry.startedOn.formattedString(customDateFormat: .dateAndTime)
        
        if let until = logEntry.endedOn {
            cell.until.text = until.formattedString(customDateFormat: .timeOnly)
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
