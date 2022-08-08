//
//  ViewController.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/07/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class NicknameSetupVC: UIViewController, SnapKitType {
    
    weak var coordinator: LoginCoordinating?
    var disposeBag = DisposeBag()
    
    let titleLabel = UILabel().then {
        $0.text = "닉네임 설정하기"
        $0.textAlignment = .left
        $0.font = FontManager.shared.notoSansKR(.bold, 26)
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    let subtitleLabel = UILabel().then {
        $0.text = "한글/영문 + 숫자로 15글자까지 가능합니다."
        $0.textColor = .f4
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
    }
    
    let textField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
    }
    
    let completeButton = GLButton().then {
        $0.title = "완료"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addComponents()
        setConstraints()
        bind()
        view.backgroundColor = .white
    }
    
    func addComponents() {
        [titleLabel, subtitleLabel, textField, completeButton].forEach { view.addSubview($0) }
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(68)
            $0.left.equalToSuperview().inset(Const.padding)
        }
        
        textField.snp.makeConstraints {
            $0.width.equalTo(Const.glBtnWidth)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        completeButton.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(50)
            $0.width.equalTo(Const.glBtnWidth)
            $0.height.equalTo(Const.glBtnHeight)
            $0.centerX.equalToSuperview()
        }

        
    }
    
    func bind() {
        completeButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.coordinator?.moveToLoginPage()
            })
            .disposed(by: disposeBag)
    }
    
}
