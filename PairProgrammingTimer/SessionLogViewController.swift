//
//  SessionLogViewController.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 11.04.17.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import UIKit

class SessionLogEntryCell : UITableViewCell {
    @IBOutlet weak var developerName: UILabel!
    @IBOutlet weak var otherDeveloperName: UILabel!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var until: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var sessionDuration: UILabel!
    @IBOutlet weak var sessionDurationDifference: UILabel!
}

class SessionLogViewController: UIViewController {
    
    @IBOutlet weak var tableViewLogEntries: UITableView!
    
    weak var sessionLog: SessionLog?
    
    fileprivate var logEntries = [SessionLogEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sessionLog = SessionViewController.sessionLog
        sessionLog?.delegate = self
        
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
