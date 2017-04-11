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
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var until: UILabel!
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
        
        logEntries = sessionLog.entries
        
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY HH:mm:SS"
        
        cell.from.text = dateFormatter.string(from: logEntry.startedOn)
        
        if let until = logEntry.endedOn {
            cell.until.text = dateFormatter.string(from: until)
        } else {
            cell.until.text = ""
        }
        
        return cell
    }
}
