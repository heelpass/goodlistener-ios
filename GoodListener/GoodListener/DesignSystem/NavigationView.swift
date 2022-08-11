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
    
    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = .clear
        $0.spacing = 13
    }
    
    let backBtn = UIButton().then {
        $0.setImage(UIImage(named: "ic_navi_back_btn"), for: .normal)
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
    }
    
    let rightBtn = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        [stackView, logo, rightBtn].forEach { addSubview($0) }
        [backBtn, title].forEach {
            stackView.addArrangedSubview($0)
            $0.isHidden = true
        }
        
        stackView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(6)
            $0.centerY.equalToSuperview()
        }
        
        title.snp.makeConstraints {
            $0.centerY.equalToSuperview()
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
            rightBtn.layer.cornerRadius = 10
            rightBtn.setTitle("저장", for: .normal)
            rightBtn.backgroundColor = .m1
            rightBtn.setTitleColor(.white, for: .normal)
            rightBtn.titleLabel?.font = FontManager.shared.notoSansKR(.bold, 13)
            rightBtn.snp.remakeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview().inset(16)
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
