//
//  LetterViewController.swift
//  booIOS
//
//  Created by candy on 2017. 8. 3..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit

class LetterViewController: UIViewController {
    
    var container: ContainerViewController!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDefaults.set(0, forKey: "notReadPush")
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("앱 뱃지 0됨 ^0^")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            container!.segueIdentifierReceivedFromParent("noticeLetter")
        }else{
            container!.segueIdentifierReceivedFromParent("attendLetter")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "letterContainer"{
            
            container = segue.destination as! ContainerViewController
        }
    }
    
}
