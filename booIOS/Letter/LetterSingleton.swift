//
//  File.swift
//  booIOS
//
//  Created by candy on 2017. 8. 7..
//  Copyright © 2017년 univ. All rights reserved.
//

import Foundation


class LetterSingleton {
    
    static let _sharedInstance = LetterSingleton()
    
    var noticeLetterBody:String?
    
    var noticeLetterName:String?
    
    var noticeLetterTitle:String?
    
    var noticeLetterID:String?
    
    private init() {
    }
}
