//
//  TripsTableViewCell.swift
//  TripLog
//
//  Created by Lyra Ding on 5/7/17.
//  Copyright © 2017 CS466. All rights reserved.
//

import UIKit

class TripsTableViewCell: UITableViewCell {

    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    func configureCell(trip:Trip){
        tripNameLabel.text = trip.tripName
        startDateLabel.text = trip.startDate
        endDateLabel.text = trip.endDate
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
