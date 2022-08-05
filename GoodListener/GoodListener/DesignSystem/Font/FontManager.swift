//
//  FontManager.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/05.
//

import Foundation
import UIKit

/**
 Use it when you want to modify the font with code ( Use shared Instance )
 
 Usable Font
 
 - NotoSansKR
 - SUIT
 */

struct FontManager {
    
    static let shared = FontManager()
    
    enum NotoSansKR: String {
        case light = "Light"
        case bold = "Bold"
        case thin = "Thin"
        case black = "Black"
        case medium = "Medium"
        case regular = "Regular"
    }
    
    /**
      NotoSansKR

      - parameters:
        - type: 폰트 타입
        - size: 폰트 크기
     
      - returns: UIFont

    */
    func notoSansKR(_ type: NotoSansKR ,_ size: CGFloat)-> UIFont {
        let name = "NotoSansKR-" + type.rawValue
        
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
