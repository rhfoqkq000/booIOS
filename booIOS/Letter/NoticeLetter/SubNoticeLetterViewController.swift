//
//  SubNoticeLetterViewController.swift
//  booIOS
//
//  Created by candy on 2017. 8. 3..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit

class SubNoticeLetterViewController: UIViewController {
    @IBOutlet weak var fromTo: UITextView!
    @IBOutlet weak var contentTitle: UITextView!
    @IBOutlet weak var content: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        fromTo.textaddBorderBottom(height: 1, color: UIColor.darkGray)
        contentTitle.textaddBorderBottom(height: 1, color: UIColor.darkGray)
        
        fromTo.text = "보낸이"
        contentTitle.text = "제목"
        content.text = "내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용"
        adjustUITextViewHeight(content)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adjustUITextViewHeight(_ arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
}
