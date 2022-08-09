//
//  TitleView.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/09.
//

import UIKit
import SnapKit
import Then

enum NaviButtonCase: String {
    case notice = "ic_navi_noti"
    case setting = "ic_navi_setting_dark"
    case save
    
}

class NavigationView: UIView {
    
    let logo = UILabel().then {
        $0.text = "굿 리스너"
        $0.font = FontManager.shared.notoSansKR(.bold, 20)
        $0.textColor = .f2
    }
    
    let button = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(logo)
        addSubview(button)
        
        logo.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
        
        button.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
        }
    }
    
    convenience init(frame: CGRect, type: NaviButtonCase) {
        self.init(frame: frame)
        
        switch type {
        case .notice:
            button.setImage(UIImage(named: type.rawValue), for: .normal)
        case .setting:
            button.setImage(UIImage(named: type.rawValue), for: .normal)
        case .save:
            button.layer.cornerRadius = 10
            button.setTitle("저장", for: .normal)
            button.backgroundColor = .m1
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = FontManager.shared.notoSansKR(.bold, 13)
            button.snp.remakeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview().inset(16)
                $0.height.equalTo(35)
                $0.width.equalTo(50)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
