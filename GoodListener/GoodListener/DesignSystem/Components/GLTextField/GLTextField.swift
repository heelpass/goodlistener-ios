//
//  GLTextField.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/26.
//

import Foundation
import UIKit

class GLTextField: UIView, SnapKitType {
    
    var maxCount = 0
    
    var title: String {
        get {
            return titleLbl.text ?? ""
        }
        
        set {
            titleLbl.text = newValue
        }
    }
    
    var limit: String {
        get {
            return limitLbl.text ?? ""
        }
        
        set {
            limitLbl.text = newValue
        }
    }
    
    var checkBtnTitle: String {
        get {
            return checkBtn.title
        }
        
        set {
            checkBtn.title = newValue
        }
    }
    
    let titleLbl = UILabel().then {
        $0.text = "닉네임"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f3
    }
    
    let tfContainer = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let inputTf = UITextField().then {
        $0.borderStyle = .none
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
    }
    
    let checkBtn = UIButton().then {
        $0.title = "중복확인"
        $0.titleColor = .f4
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = false
    }
    
    let tfUnderLine = UIView().then {
        $0.backgroundColor = .black
    }
    
    lazy var limitLbl = UILabel().then {
        $0.text = "*한글/영문 + 숫자로 \(self.maxCount)글자까지 가능합니다."
        $0.textColor = .f4
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(maxCount: Int) {
        self.init(frame: .zero)
        self.maxCount = maxCount
        
        addComponents()
        setConstraints()
        
        // keyboardWillShow, keyboardWillHide observer 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addComponents() {
        [titleLbl, tfContainer].forEach { addSubview($0) }
        [inputTf, checkBtn, tfUnderLine, limitLbl].forEach { tfContainer.addSubview($0) }
    }
    
    func setConstraints() {
        titleLbl.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().inset(Const.padding)
        }
        
        tfContainer.snp.makeConstraints {
            $0.top.equalTo(titleLbl.snp.bottom).offset(35)
            $0.left.right.equalToSuperview().inset(Const.padding)
        }
        
        inputTf.snp.makeConstraints {
            $0.left.top.equalToSuperview()
        }
        
        checkBtn.snp.makeConstraints {
            $0.right.top.equalToSuperview()
            $0.left.equalTo(inputTf.snp.right).offset(10)
            $0.width.equalTo(52)
            $0.height.equalTo(20)
        }
        
        tfUnderLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(inputTf.snp.bottom).offset(5)
        }
        
        limitLbl.snp.makeConstraints {
            $0.top.equalTo(tfUnderLine.snp.bottom).offset(10)
            $0.left.bottom.equalToSuperview()
        }
        
    }
    
    @objc func keyboardWillShow(_ notification:NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        superview?.subviews.forEach {
            if $0.tag != self.tag {
                $0.isHidden = true
            }
        }
        
        [self].forEach {
            $0.transform = CGAffineTransform.init(translationX: 0, y: -calculateTranslationY(keyboardHeight))
        }
    }


    @objc func keyboardWillHide(_ notification:NSNotification) {
        guard let _ = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        superview?.subviews.forEach {
            if $0.tag != self.tag {
                $0.isHidden = false
            }
        }
        
        [self].forEach {
            $0.transform = .identity
        }
    }
}
