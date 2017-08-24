//
//  UnderLine.swift
//  booIOS
//
//  Created by candy on 2017. 8. 7..
//  Copyright © 2017년 univ. All rights reserved.
//

import Foundation

extension UITextField {
    func addBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height-height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
