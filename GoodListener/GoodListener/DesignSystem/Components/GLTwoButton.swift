//
//  GLTwoButton.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/08/21.
//

import UIKit

class GLTwoButton: UIView, SnapKitType {

    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = .clear
        $0.distribution = .fillEqually
    }
    
    let cancelBtn = UIButton().then {
        $0.backgroundColor = .m5
        $0.layer.borderColor = CGColor(red: 94/255, green: 199/255, blue: 92/255, alpha: 1)
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 2
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.setTitleColor(.m1, for: .normal)

    }
    
    let okBtn = UIButton().then {
        $0.backgroundColor = .m1
        $0.layer.borderColor = CGColor(red: 94/255, green: 199/255, blue: 92/255, alpha: 1)
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 2
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.setTitleColor(.m5, for: .normal)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        setConstraints()
    }
    
    func addComponents() {
        addSubview(stackView)
        [cancelBtn, okBtn].forEach{
            stackView.addArrangedSubview($0)
        }
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        stackView.setCustomSpacing(15, after: cancelBtn)
    }
}
