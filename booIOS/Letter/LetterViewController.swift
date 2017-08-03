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
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
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
        if segue.identifier == "container"{
            
            container = segue.destination as! ContainerViewController 
        }
    }

}
