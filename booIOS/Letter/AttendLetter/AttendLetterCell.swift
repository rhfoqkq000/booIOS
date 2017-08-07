//
//  AttendLetterCell.swift
//  booIOS
//
//  Created by candy on 2017. 8. 3..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit

class AttendLetterCell: UITableViewCell {
    
    @IBOutlet weak var attendLetterMainView: UIView!
    @IBOutlet weak var attendLetterSubView: UIView!
    
    @IBOutlet weak var attendLetterDate: UILabel!
    @IBOutlet weak var attendLetterName: UILabel!
    @IBOutlet weak var attendLetterTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
