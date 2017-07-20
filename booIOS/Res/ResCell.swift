//
//  ResCell.swift
//  res
//
//  Created by candy on 2017. 6. 26..
//  Copyright © 2017년 candy. All rights reserved.
//

import UIKit

class ResCell: UITableViewCell {

    @IBOutlet weak var resName: UILabel!
    @IBOutlet weak var resContent: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
