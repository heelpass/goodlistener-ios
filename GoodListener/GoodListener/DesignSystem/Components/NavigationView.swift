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
    case none
}

class NavigationView: UIView {
    
    let backBtn = UIButton().then {
        $0.setImage(UIImage(named: "ic_navi_back_btn"), for: .normal)
        $0.isHidden = true
    }
    
    let logo = UILabel().then {
        $0.text = "굿 리스너"
        $0.font = FontManager.shared.notoSansKR(.bold, 20)
        $0.textColor = .f2
    }
    
    let title = UILabel().then {
        $0.text = "title"
        $0.font = FontManager.shared.notoSansKR(.regular, 18)
        $0.textColor = .f2
        $0.isHidden = true
    }
    
    let rightBtn = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        [backBtn, title, logo, rightBtn].forEach { addSubview($0) }
        
        backBtn.snp.makeConstraints {
            $0.left.equalToSuperview().inset(6)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(36)
        }
        
        title.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        logo.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
        
        rightBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
        }
    }
    
    convenience init(frame: CGRect, type: NaviButtonCase) {
        self.init(frame: frame)
        
        switch type {
        case .notice:
            rightBtn.setImage(UIImage(named: type.rawValue), for: .normal)
        case .setting:
            rightBtn.setImage(UIImage(named: type.rawValue), for: .normal)
        case .save:
            rightBtn.setTitle("저장", for: .normal)
            rightBtn.backgroundColor = .clear
            rightBtn.setTitleColor(.f3, for: .normal)
            rightBtn.titleLabel?.font = FontManager.shared.notoSansKR(.bold, 16)
            rightBtn.snp.remakeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview().inset(6)
                $0.height.equalTo(44)
                $0.width.equalTo(50)
            }
        case .none:
            rightBtn.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
