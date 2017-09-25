//
//  ResSingleton.swift
//  booIOS
//
//  Created by candy on 2017. 9. 2..
//  Copyright © 2017년 univ. All rights reserved.
//

import Foundation

class ResSingleton {
    
    static let _sharedInstance = ResSingleton()
    
    var hadan:String?
    
    var bumin:String?
    
    private init() {
    }
}
