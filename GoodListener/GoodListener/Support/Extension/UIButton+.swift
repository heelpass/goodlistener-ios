//
//  UIButton+.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/05.
//

import Foundation
import UIKit

extension UIButton {
    var title: String {
        get {
            return self.title(for: .normal) ?? ""
        }
        
        set {
            setTitle(newValue, for: .normal)
        }
        
    }
    
    var titleColor: UIColor {
        get {
            return self.titleColor(for: .normal) ?? .f6
        }
        
        set {
            setTitleColor(newValue, for: .normal)
        }
    }
    
    var color: UIColor {
        get {
            return self.backgroundColor ?? .m1
        }
        
        set {
            backgroundColor = newValue
        }
    }
    
    var font: UIFont {
        get {
            return self.titleLabel?.font ?? FontManager.shared.notoSansKR(.bold, 16)
        }
        
        set {
            self.titleLabel?.font = newValue
        }
    }
}
