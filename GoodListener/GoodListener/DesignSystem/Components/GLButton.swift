//
//  GLButton.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/05.
//

import UIKit

enum GLButtonState {
    case active
    case deactivate
}

/**
 높이 48 공통 버튼
 */
// SnapKit으로 Constaint 잡을때
// width.equalTo(Const.glBtnWidth)
// height.equalTo(Const.glBtnHeight)
// 잡아주세요~~
class GLButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = Const.glBtnHeight / 2
        setTitle("버튼", for: .normal)
        backgroundColor = .m1
        setTitleColor(.white, for: .normal)
        titleLabel?.font = FontManager.shared.notoSansKR(.bold, 16)
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - Const.padding * 2, height: Const.glBtnHeight)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configUI(_ type: GLButtonState) {
        switch type {
        case .active:
            backgroundColor = .m1
            self.isUserInteractionEnabled = true
        case .deactivate:
            backgroundColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            self.isUserInteractionEnabled = false
        }
    }
    
}
