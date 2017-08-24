//
//  SeatSubViewController.swift
//  booIOS
//
//  Created by candy on 2017. 8. 24..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit

class SeatDetailViewController: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    var sendURL = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: sendURL)
        let myURLRequest:URLRequest = URLRequest(url: url!)
        webview.loadRequest(myURLRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
