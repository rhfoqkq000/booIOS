//
//  VersionViewController.swift
//  booIOS
//
//  Created by candy on 2017. 8. 9..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit

class VersionViewController: UIViewController {
    
    @IBOutlet weak var currentVersion: UILabel!
    @IBOutlet weak var UpdateVersion: UILabel!
    
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            currentVersion.text = version
        }
        
        UpdateVersion.isHidden = true
        label.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

}
