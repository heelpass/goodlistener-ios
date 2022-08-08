//
//  AuthViewController.swift
//  GoodListener
//
//  Created by cheonsong on 2022/07/26.
//

import UIKit
import SnapKit
import RxGesture
import RxSwift
import Then

class AuthViewController: UIViewController, SnapKitType {
    
    weak var coordinator: LoginCoordinating?
    
    var disposeBag = DisposeBag()
    
    let titleLabel = UILabel().then {
        $0.text = "더 안전한\n음성대화를 위해\n번호인증을 해주세요"
        $0.textAlignment = .left
        $0.font = FontManager.shared.notoSansKR(.bold, 26)
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.textColor = .f2
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
    }
    
    let nameTf = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
    }
    
    let registrationLabel = UILabel().then {
        $0.text = "주민번호"
        $0.textColor = .f2
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
    }
    
    let registrationTf = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
    }
    
    let phoneLabel = UILabel().then {
        $0.text = "휴대폰 번호"
        $0.textColor = .f2
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
    }
    
    let phoneTf = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
    }
    
    let authLabel = UILabel().then {
        $0.text = "인증번호"
        $0.textColor = .f2
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
    }
    
    let authTf = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
    }
    
    let sendButton = GLButton().then {
        $0.title = "인증번호 발송"
        $0.titleColor = .white
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        addComponents()
        setConstraints()
    }
    
    func addComponents() {
        [titleLabel, nameLabel, nameTf, registrationLabel, registrationTf, phoneLabel, phoneTf, authLabel, authTf, sendButton].forEach {
            view.addSubview($0)
        }
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(68)
            $0.left.equalToSuperview().inset(Const.padding)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.left.equalToSuperview().inset(Const.padding)
            $0.width.equalTo(phoneLabel)
        }
        
        nameTf.snp.makeConstraints {
            $0.left.equalTo(nameLabel.snp.right).offset(30)
            $0.width.equalTo(200)
            $0.centerY.equalTo(nameLabel)
        }
        
        registrationLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(40)
            $0.left.equalToSuperview().inset(Const.padding)
            $0.width.equalTo(phoneLabel)
        }
        
        registrationTf.snp.makeConstraints {
            $0.left.equalTo(registrationLabel.snp.right).offset(30)
            $0.width.equalTo(200)
            $0.centerY.equalTo(registrationLabel)
        }
        
        phoneLabel.snp.makeConstraints {
            $0.top.equalTo(registrationLabel.snp.bottom).offset(40)
            $0.left.equalToSuperview().inset(Const.padding)
        }
        
        phoneTf.snp.makeConstraints {
            $0.left.equalTo(phoneLabel.snp.right).offset(30)
            $0.width.equalTo(200)
            $0.centerY.equalTo(phoneLabel)
        }
        
        authLabel.snp.makeConstraints {
            $0.top.equalTo(phoneLabel.snp.bottom).offset(50)
            $0.left.equalToSuperview().inset(Const.padding)
        }
        
        authTf.snp.makeConstraints {
            $0.top.equalTo(authLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(Const.padding)
            $0.width.equalTo(150)
        }
        
        sendButton.snp.makeConstraints {
            $0.left.equalTo(authTf.snp.right).offset(40)
            $0.centerY.equalTo(authTf)
            $0.height.equalTo(Const.glBtnHeight)
            $0.width.equalTo(115)
        }
    }

}
