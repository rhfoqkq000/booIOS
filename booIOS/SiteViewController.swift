//
//  SiteViewController.swift
//  booIOS
//
//  Created by candy on 2017. 7. 24..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit

class SiteViewController: UIViewController,UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: "http://donga.ac.kr") {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
