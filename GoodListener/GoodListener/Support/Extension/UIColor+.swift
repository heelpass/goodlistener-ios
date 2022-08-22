//
//  UIColor+.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/22.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init( r: CGFloat,g: CGFloat, b: CGFloat, a: CGFloat = 1.0 ){
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red:red, green:green, blue:blue, alpha:a)
    }
    
    convenience init(rgb: CGFloat, a: CGFloat = 1.0) {
        let rgb = rgb / 255.0
        self.init(red: rgb, green: rgb, blue: rgb, alpha:a)
    }
}
