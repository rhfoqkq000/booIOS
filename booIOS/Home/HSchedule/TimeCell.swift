//
//  TimeCell.swift
//  booIOS
//
//  Created by pmkjkr on 2017. 7. 25..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit

class TimeCell: UITableViewCell {

    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var roomLabel: UILabel!
    @IBOutlet weak var noText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
