//
//  StuTabBarController.swift
//  booIOS
//
//  Created by candy on 2017. 7. 11..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit

class StuTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWill")
        
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWill")
    }
}
