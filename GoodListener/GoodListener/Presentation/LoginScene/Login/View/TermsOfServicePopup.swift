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

class TermsOfServicePopup: UIView, SnapKitType {
    
    let disposeBag = DisposeBag()
    
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
    
    private let contentsLbl = UILabel().then {
        $0.text = TermsOfService.full
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f2
        $0.textFontChange(text: $0.text!, font: FontManager.shared.notoSansKR(.bold, 15), range: ["제 1조 (목적)", "제 2조 (용어의 정의)", "제 3조 (예시)", "제 4조 (예시)","제 5조 (예시)","제 6조 (예시)","제 7조 (예시)"])
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
}
