//
//  TermsOfServicePopup.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/25.
//

import Foundation
import UIKit
import Then
import RxSwift
import RxCocoa
import SnapKit

enum ServicePopupType {
    case termsOfService
    case PersonalInformation
}

class TermsOfServicePopup: UIView, SnapKitType {
    
    let disposeBag = DisposeBag()
    
    var type: ServicePopupType = .PersonalInformation
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.6)
    }
    
    private let container = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
    }
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let titleLbl = UILabel().then {
        $0.text = "이용 약관"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f2
        $0.sizeToFit()
    }
    
    lazy var contentsLbl = UILabel().then {
        if type == .termsOfService {
            $0.text = TermsOfService.full
        } else {
            $0.text = PersonalInformation.full
        }
        
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f2
        $0.numberOfLines = 0
    }
    
    private let completeBtn = UIButton().then {
        $0.title = "확인"
        $0.font = FontManager.shared.notoSansKR(.bold, 14)
        $0.titleColor = .m1
        $0.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        setConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        completeBtn.layer.addBorder([.top], color: .f6, width: 1)
    }
    
    func addComponents() {
        [backgroundView, container].forEach { addSubview($0) }
        [titleLbl, scrollView, completeBtn].forEach { container.addSubview($0) }
        scrollView.addSubview(contentsLbl)
    }
    
    func setConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        container.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(Const.glBtnWidth)
            $0.height.equalTo(UIScreen.main.bounds.height - 110)
        }
        
        titleLbl.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(titleLbl.snp.bottom).offset(17)
            $0.bottom.equalTo(completeBtn.snp.top).offset(-24)
        }
        
        contentsLbl.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20)
            $0.width.equalTo(Const.glBtnWidth-40)
        }
        
        completeBtn.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(Const.glBtnHeight)
        }
    }
    
    func bind() {
        completeBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.removeFromSuperview()
            })
            .disposed(by: disposeBag)
        
        backgroundView.tapGesture
            .subscribe(onNext: { [weak self] _ in
                self?.removeFromSuperview()
            })
            .disposed(by: disposeBag)
    }
    
    func configUI() {
        if type == .termsOfService {
            contentsLbl.text = TermsOfService.full
            titleLbl.text = "서비스이용약관"
        } else {
            contentsLbl.text = PersonalInformation.full
            titleLbl.text = "개인정보 처리방침"
        }
    }
}
