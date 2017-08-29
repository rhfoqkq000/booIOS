//
//  PrivacyViewController.swift
//  booIOS
//
//  Created by candy on 2017. 8. 9..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController {
    let userDefaults = UserDefaults.standard

    @IBAction func toLoginAction(_ sender: AnyObject) {
        userDefaults.set(1, forKey: "privacyAgreement")
        self.performSegue(withIdentifier: "toLoginSeque", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userDefaults.integer(forKey: "privacyAgreement") == 1{
//            self.performSegue(withIdentifier: "toLoginSeque", sender: self)
            DispatchQueue.main.async() {
                self.performSegue(withIdentifier: "toLoginSeque", sender: self)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
