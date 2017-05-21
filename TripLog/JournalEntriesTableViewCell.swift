//
//  JournalEntriesTableViewCell.swift
//  TripLog
//
//  Created by Lyra Ding on 4/24/17.
//  Copyright © 2017 CS466. All rights reserved.
//

import UIKit

//this is the file for the cells for single journal entries
//you can see these cells when viewing individual trip's journal entries
//or when viewing all the journal entries together

class JournalEntriesTableViewCell: UITableViewCell {

    @IBOutlet weak var journalEntryTextLabel: UILabel!
    @IBOutlet weak var journalEntryDateLabel: UILabel!
    @IBOutlet weak var journalEntryTripNameLabel: UILabel!
    @IBOutlet weak var journalEntryTripIndexLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(entry:JournalEntry) {
        let tempAttributedString:NSAttributedString = entry.text as! NSAttributedString
        journalEntryTextLabel.text = tempAttributedString.string
        journalEntryDateLabel.text = entry.date
        journalEntryTripIndexLabel.text = ""
        journalEntryTripNameLabel.text = entry.trip?.tripName
    }

}
