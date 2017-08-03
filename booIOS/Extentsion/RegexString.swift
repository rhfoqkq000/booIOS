//
//  RegexString.swift
//  booIOS
//
//  Created by candy on 2017. 8. 2..
//  Copyright © 2017년 univ. All rights reserved.
//

import Foundation

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
