//
//  GLTextView.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/08/23.
//

import UIKit

class GLTextView: UIView, SnapKitType, UITextViewDelegate {
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .clear
    }
    
    let baseView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1).cgColor
    }
    
    let reasonTV =  UITextView().then {
        $0.text = "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십"
        $0.textColor = .f7
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
    }
    
    let descriptionLbl = UILabel().then {
        $0.text = "* 최대 50글자까지 가능합니다"
        $0.font = FontManager.shared.notoSansKR(.regular, 12)
        $0.textColor = .f4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        setConstraints()
        reasonTV.delegate = self
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//       endEditing(true)
//    }
    
    func addComponents() {
        addSubview(stackView)
        [baseView, descriptionLbl].forEach{
            stackView.addArrangedSubview($0)
        }
        baseView.addSubview(reasonTV)
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        stackView.setCustomSpacing(6, after: baseView)
        reasonTV.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if reasonTV.text.count > 50 {
            reasonTV.deleteBackward()
        }
    }
}
