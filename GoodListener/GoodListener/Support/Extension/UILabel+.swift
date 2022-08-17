//
//  UILabel+.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/08.
//

import Foundation
import UIKit

extension UILabel {
    // 컬러만 변경
    func textColorChange(text: String, color: UIColor, range: String){
        let attributedStr = NSMutableAttributedString(string: text)
        attributedStr.addAttribute(.foregroundColor, value: color, range: (text as NSString).range(of: range))
        
        self.attributedText = attributedStr
    }
    // 폰트만 변경
    func textFontChange(text: String, font: UIFont, range: String){
        let attributedStr = NSMutableAttributedString(string: text)
        attributedStr.addAttribute(.font, value: font, range: (text as NSString).range(of: range))
        
        self.attributedText = attributedStr
    }
    // 컬러, 폰트 변경
    func textColorAndFontChange(text: String, color: UIColor, font: UIFont, range: String){
        let attributedStr = NSMutableAttributedString(string: text)
        attributedStr.addAttribute(.foregroundColor, value: color, range: (text as NSString).range(of: range))
        attributedStr.addAttribute(.font, value: font, range: (text as NSString).range(of: range))
        
        self.attributedText = attributedStr
        
    }
}
