//
//  ResSegueViewController.swift
//  booIOS
//
//  Created by candy on 2017. 8. 23..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit

class ResSegueViewController: UIViewController {
    
    var container: ContainerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            container!.segueIdentifierReceivedFromParent("hadan")
        }else{
            container!.segueIdentifierReceivedFromParent("bumin")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resContainer"{
            container = segue.destination as! ContainerViewController
        }
    }

}
