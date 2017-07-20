//
//  SeatTableViewCell.swift
//  seat
//
//  Created by rokhun on 2017. 7. 4..
//  Copyright © 2017년 rokhun. All rights reserved.
//

import UIKit

class SeatTableViewCell: UITableViewCell {
    
    @IBOutlet var seatNameLabel: UILabel!
    @IBOutlet var seatTotalCountLabel: UILabel!
    @IBOutlet var seatUserLabel: UILabel!
    @IBOutlet var seatLeftLabel: UILabel!
    @IBOutlet var seatUseRatingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
