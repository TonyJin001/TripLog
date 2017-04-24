//
//  FirstViewController.swift
//  TripLog
//
//  Created by Lyra Ding on 4/23/17.
//  Copyright © 2017 CS466. All rights reserved.
//

import UIKit

class JournalEntriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var journalEntriesTableView: UITableView!
    
    // Dummy data used for testing the table view
    let dummyDataText = ["Last week I went to NYC", "It's Christmas and...", "Today I went to the Empire State Building"]
    let dummyDataDate = ["01/01/17","12/24/16","10/19/16"]
    let dummyDataTripName = ["New York Trip", "", "Fall Break"]
    let dummyDataTripIndex = ["#1","","#2"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        journalEntriesTableView.delegate = self
        journalEntriesTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyDataText.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JournalEntriesTableViewCell", for: indexPath) as? JournalEntriesTableViewCell else {
            fatalError("Can't get cell of the right kind")
        }
        
        cell.journalEntryTextLabel.text = dummyDataText[indexPath.row]
        cell.journalEntryDateLabel.text = dummyDataDate[indexPath.row]
        cell.journalEntryTripNameLabel.text = dummyDataTripName[indexPath.row]
        cell.journalEntryTripIndexLabel.text = dummyDataTripIndex[indexPath.row]
        
        return cell
    }


}

