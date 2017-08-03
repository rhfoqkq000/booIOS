//
//  NoticeLetterCell.swift
//  booIOS
//
//  Created by candy on 2017. 8. 3..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit

class NoticeLetterCell: UITableViewCell {

    @IBOutlet weak var noticeLetterMainView: UIView!
    @IBOutlet weak var noticeLetterSubView: UIView!
    
    @IBOutlet weak var noticeLetterDate: UILabel!
    @IBOutlet weak var noticeLetterName: UILabel!
    @IBOutlet weak var noticeLetterTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
