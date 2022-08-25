//
//  GLTextView.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/25.
//

import Foundation
import UIKit

class GLTextView: UIView, SnapKitType {
    
    /// 제목
    var title: String {
        get {
            return titleLbl.text ?? ""
        }
        
        set {
            titleLbl.text = newValue
        }
    }
    
    /// 컨텐츠
    var contents: String {
        get {
            return contentsTv.text
        }
        
        set {
            contentsTv.text = newValue
        }
    }
    
    ///  maxCount
    var maxCount = 0
    
    /// 스크롤 가능 여부
    var isScrollEnabled: Bool {
        get {
            return contentsTv.isScrollEnabled
        }
        
        set {
            contentsTv.isScrollEnabled = newValue
        }
    }
    
    /// 수정가능 여부 TRUE: 가능, FALSE: 불가능
    var isEditable: Bool {
        get {
            return contentsTv.isEditable
        }
        
        set {
            contentsTv.isEditable = newValue
        }
    }
    
    private let container = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let titleLbl = UILabel().then {
        $0.text = "제목"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f2
        $0.sizeToFit()
    }
    
    private let contentsContainer = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor.f6.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
    }
    
    private lazy var contentsTv = UITextView().then {
        $0.text = "일이삼사오육칠팔구십 일이삼사오육칠팔구십 일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사"
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.backgroundColor = .clear
        $0.textColor = .f7
        $0.textAlignment = .left
        $0.backgroundColor = .clear
        $0.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        $0.showsHorizontalScrollIndicator = false
        $0.delegate = self
    }
    
    private let descriptionLbl = UILabel().then {
        $0.font = FontManager.shared.notoSansKR(.regular, 12)
        $0.textColor = .f4
        $0.text = "*최대 ~글자까지 가능합니다"
        $0.sizeToFit()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(maxCount: Int) {
        self.init(frame: .zero)
        self.maxCount = maxCount
        descriptionLbl.text = "*최대 \(maxCount)글자까지 가능합니다"
        addComponents()
        setConstraints()
    }
    
    func addComponents() {
        [titleLbl, contentsContainer, descriptionLbl].forEach { addSubview($0) }
        contentsContainer.addSubview(contentsTv)
    }
    
    func setConstraints() {
        titleLbl.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().inset(Const.padding)
            $0.height.equalTo(titleLbl.frame.height)
        }
        
        contentsContainer.snp.makeConstraints {
            $0.top.equalTo(titleLbl.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(Const.padding)
        }
        
        contentsTv.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(10)
        }
        
        descriptionLbl.snp.makeConstraints {
            $0.top.equalTo(contentsContainer.snp.bottom).offset(3)
            $0.left.equalToSuperview().inset(Const.padding)
            $0.bottom.equalToSuperview()
        }
    }
    
    func glTextViewHeight(textViewHeight: CGFloat)-> CGFloat {
        var height: CGFloat = 0
        height += titleLbl.frame.height
        height += descriptionLbl.frame.height
        height += textViewHeight
        height += (12 + 3)
        return height
    }
}

extension GLTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > maxCount {
            textView.deleteBackward()
        }
    }
}
