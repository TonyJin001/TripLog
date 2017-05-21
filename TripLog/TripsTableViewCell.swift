//
//  TripsTableViewCell.swift
//  TripLog
//
//  Created by Lyra Ding on 5/7/17.
//  Copyright © 2017 CS466. All rights reserved.
//

import UIKit

//This is the file for the cells in the trips table view

class TripsTableViewCell: UITableViewCell {

    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    func configureCell(trip:Trip){
        var startDate = ""
        var endDate = ""
        
        tripNameLabel.text = trip.tripName
        tripNameLabel.adjustsFontSizeToFitWidth = true
        
        if trip.startDate != nil {
            startDate = "From: " + trip.startDate!
        }
        startDateLabel.text = startDate
        if trip.endDate != nil {
            endDate = "To:     " + trip.endDate!
        }
        endDateLabel.text = endDate
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
