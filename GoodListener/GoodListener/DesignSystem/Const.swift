//
//  Const.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/05.
//

import Foundation
import UIKit

struct Const {
    static let padding: CGFloat = 30
    
    static let tabBarWidth: CGFloat = UIScreen.main.bounds.width - 120
    static let tabBarHeight: CGFloat = 64
    
    static let glBtnHeight: CGFloat = 48
    static let glBtnWidth: CGFloat = UIScreen.main.bounds.width - (padding * 2)
    
    static let glTfHeight: CGFloat = 118
}

// TODO: 백엔드에서 이미지 코드 정해지면 수정! , Assets에서 파일명도 코드와 동일하게 수정필요
enum Image: String {
    case profile1
    case profile2
    case profile3
    case profile4
    case profile5
    case profile6
    
    case emoji1
    case emoji2
    case emoji3
    case emoji4
    case emoji5
}
