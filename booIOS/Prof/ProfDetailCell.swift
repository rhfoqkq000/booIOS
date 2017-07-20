//
//  ProfDetailCell.swift
//  prof
//
//  Created by candy on 2017. 7. 5..
//  Copyright © 2017년 candy. All rights reserved.
//

import UIKit


class ProfDetailCell: UITableViewCell {

    @IBOutlet weak var profName: UILabel!
    @IBOutlet weak var profMajor: UILabel!
    @IBOutlet weak var profCall: UIButton!
    @IBOutlet weak var profMail: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
