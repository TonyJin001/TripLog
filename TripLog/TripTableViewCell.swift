//
//  TripTableViewCell.swift
//  TripLog
//
//  Created by Vaasu on 4/24/17.
//  Copyright © 2017 CS466. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    @IBOutlet weak var startdateLabel: UILabel!
    @IBOutlet weak var enddateLabel: UILabel!
    @IBOutlet weak var tripnameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
