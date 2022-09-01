//
//  SimplePopup.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/18.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
/**
    title, contents, completeAction, cancelAction, cancelIsHidden 프로퍼티로 설정 가능
 */
class GLPopup: UIView, SnapKitType {
    
    var disposeBag = DisposeBag()
    /// EX) popup.title = ""
    var title: String {
        get {
            return titleLbl.text ?? ""
        }
        
        set {
            titleLbl.text = newValue
        }
    }
    
    /// EX) popup.contents = ""
    var contents: String {
        get {
            return contentsLbl.text ?? ""
        }
        
        set {
            contentsLbl.text = newValue
        }
    }
    
    /// EX) popup.cancelIsHidden = true
    var cancelIsHidden: Bool {
        get {
            return cancelBtn.isHidden
        }
        
        set {
            cancelBtn.isHidden = newValue
        }
    }
    
    var alignment: NSTextAlignment {
        get {
            return titleLbl.textAlignment
        }
        
        set {
            titleLbl.textAlignment = newValue
            contentsLbl.textAlignment = newValue
        }
    }
    
    var completeBtnTitle: String {
        get {
            return completeBtn.title
        }
        
        set {
            completeBtn.title = newValue
        }
    }
    
    var cancelBtnTitle: String {
        get {
            return cancelBtn.title
        }
        
        set {
            cancelBtn.title = newValue
        }
    }
    
    /// EX) popup.completeAction = { ~~ }
    var completeAction: (()->Void)? = nil
    /// EX) popup.cancelAction = { ~~ }
    var cancelAction: (()->Void)? = nil
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.6)
    }
    
    private let container = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
    }
    
    private let titleLbl = UILabel().then {
        $0.text = "타이틀"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f2
        $0.textAlignment = .center
    }
    
    private let contentsLbl = UILabel().then {
        $0.text = "컨텐츠"
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f2
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let buttonStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
    private let completeBtn = UIButton().then {
        $0.title = "확인"
        $0.font = FontManager.shared.notoSansKR(.bold, 14)
        $0.titleColor = .m1
        $0.backgroundColor = .clear
        $0.layer.addBorder([.top], color: .f6, width: 1)
    }
    
    private let cancelBtn = UIButton().then {
        $0.title = "취소"
        $0.font = FontManager.shared.notoSansKR(.bold, 14)
        $0.titleColor = .m1
        $0.backgroundColor = .clear
        $0.layer.addBorder([.top], color: .f6, width: 1)
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
    
    override func draw(_ frame: CGRect) {
        super.draw(frame)
        if self.cancelIsHidden == true {
            completeBtn.layer.addBorder([.top], color: .f6, width: 1)
        } else {
            completeBtn.layer.addBorder([.top], color: .f6, width: 1)
            completeBtn.layer.addBorder([.left], color: .f6, width: 0.5)
            cancelBtn.layer.addBorder([.top], color: .f6, width: 1)
            cancelBtn.layer.addBorder([.right], color: .f6, width: 0.5)
        }
    }
    
    func addComponents() {
        [backgroundView, container].forEach { addSubview($0) }
        [titleLbl, contentsLbl, buttonStackView].forEach { container.addSubview($0) }
        [cancelBtn, completeBtn].forEach { buttonStackView.addArrangedSubview($0) }
    }
    
    func setConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        container.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(Const.padding)
        }
        
        titleLbl.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        contentsLbl.snp.makeConstraints {
            $0.top.equalTo(titleLbl.snp.bottom).offset(17)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(contentsLbl.snp.bottom).offset(42)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(48)
        }
    }
    
    func bind() {
        completeBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                if let action = self?.completeAction {
                    action()
                }
                self?.removeFromSuperview()
            })
            .disposed(by: disposeBag)
        
        cancelBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                if let action = self?.cancelAction {
                    action()
                }
                self?.removeFromSuperview()
            })
            .disposed(by: disposeBag)
        
        backgroundView.tapGesture
            .subscribe(onNext: { [weak self] _ in
                if let action = self?.cancelAction {
                    action()
                }
                self?.removeFromSuperview()
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        Log.d("GLPopup Deinit")
        cancelAction = nil
        completeAction = nil
    }
}
