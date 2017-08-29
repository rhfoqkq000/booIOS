//
//  CALayer.swift
//  booIOS
//
//  Created by candy on 2017. 8. 28..
//  Copyright © 2017년 univ. All rights reserved.
//

import UIKit

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let screenBounds = UIScreen.main.bounds
        let width = screenBounds.width
        let height = screenBounds.height
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height-thickness, width: self.frame.size.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: width - thickness, y: 0, width: thickness, height: height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}
