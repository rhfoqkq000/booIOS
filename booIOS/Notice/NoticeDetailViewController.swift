//
//  NoticeDetailViewController.swift
//  booIOS
//
//  Created by candy on 2017. 8. 8..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit

class NoticeDetailViewController: UIViewController {
    
    var nTitle:String = ""
    var nDate:String = ""
    var nContents:String = ""
    
    @IBOutlet weak var noticeTitle: UILabel!
    @IBOutlet weak var noticeDate: UILabel!
    @IBOutlet weak var noticeContents: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noticeTitle.text = nTitle
        noticeDate.text = nDate
        noticeContents.text = nContents

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  }
