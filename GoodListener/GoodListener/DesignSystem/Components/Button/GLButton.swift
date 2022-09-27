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

enum GLButtonType {
    case rectangle
    case round
}

/**
 높이 48 공통 버튼
 */
// SnapKit으로 Constaint 잡을때
// width.equalTo(Const.glBtnWidth)
// height.equalTo(Const.glBtnHeight)
// 잡아주세요~~
class GLButton: UIButton {
    
    lazy var highlightLayer = CAShapeLayer()
    var pressColor = UIColor(r: 83, g: 174, b: 81)
    private var isReverse = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = Const.glBtnHeight / 2
        setTitle("버튼", for: .normal)
        backgroundColor = .m1
        setTitleColor(.white, for: .normal)
        titleLabel?.font = FontManager.shared.notoSansKR(.bold, 16)
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - Const.padding * 2, height: Const.glBtnHeight)
    }
    
    convenience init(type: GLButtonType, reverse: Bool = false) {
        self.init(frame: .zero)
        switch type {
        case .rectangle:
            layer.cornerRadius = 5
        case .round:
            layer.cornerRadius = Const.glBtnHeight / 2
        }
        
        isReverse = reverse
        if reverse {
            reverseUI()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.masksToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        press()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if isReverse {
            self.titleColor = .m1
            self.layer.borderColor = UIColor.m1.cgColor
        } else {
            highlightLayer.removeFromSuperlayer()
        }
    }
    
    private func press() {
        if isReverse {
            self.titleColor = pressColor
            self.layer.borderColor = pressColor.cgColor
        } else {
            highlightLayer.fillColor = pressColor.cgColor
            highlightLayer.path = UIBezierPath(rect: self.bounds).cgPath
            
            if let firstLayer = self.layer.sublayers?.first {
                self.layer.insertSublayer(self.highlightLayer, below: firstLayer)
            }
        }
        
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
    
    func reverseUI() {
        self.layer.borderWidth = 2
        self.layer.borderColor = self.backgroundColor?.cgColor
        self.titleColor = self.backgroundColor ?? .m1
        self.backgroundColor = .white
        self.layoutIfNeeded()
    }
    
}
