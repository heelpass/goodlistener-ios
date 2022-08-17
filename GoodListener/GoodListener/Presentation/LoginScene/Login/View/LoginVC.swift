//
//  ViewController.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/07/24.
//

import UIKit
import SnapKit
import Then
import AuthenticationServices
import RxSwift
import RxCocoa


class LoginVC: UIViewController, SnapKitType {
    
    weak var coordinator: LoginCoordinating?
    var viewModel = LoginViewModel()
    var disposeBag = DisposeBag()
    
    let titleLabel = UILabel().then {
        $0.text = "우리,\n같이 마음 편하게\n이야기해볼까요?"
        $0.textAlignment = .left
        $0.font = FontManager.shared.notoSansKR(.bold, 32)
        $0.numberOfLines = 0
        $0.sizeToFit()
        $0.textColorChange(text: "우리,\n같이 마음 편하게\n이야기해볼까요?", color: .m1, range: "마음 편하게\n이야기")
    }
    
    let subtitleLabel = UILabel().then {
        $0.text = "내 마음 건강을 위한 매일 3분 보이스 루틴"
        $0.textColor = .f4
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
    }
    
    let appleLoginBtn = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
    
    let nonLoginBtn = UIButton().then{
        $0.setTitle("로그인 하지 않고 둘러보기", for: .normal)
        $0.setTitleColor(.f3, for: .normal)
        $0.titleLabel?.font = FontManager.shared.notoSansKR(.regular, 16)
        $0.layer.cornerRadius = 6
        $0.backgroundColor = .clear
        $0.titleLabel?.textUnderLine(text: "로그인 하지 않고 둘러보기", range: ["로그인 하지 않고 둘러보기"])
    }
    
    let termsOfServiceBtn = UIButton().then {
        $0.setTitle("이용약관 및 개인정보 취급방침", for: .normal)
        $0.setTitleColor(.f4, for: .normal)
        $0.titleLabel?.font = FontManager.shared.notoSansKR(.regular, 12)
        $0.backgroundColor = .clear
        $0.titleLabel?.textUnderLine(text: "이용약관 및 개인정보 취급방침", range: ["이용약관", "개인정보 취급방침"])
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
        [titleLabel, subtitleLabel, appleLoginBtn, nonLoginBtn, termsOfServiceBtn].forEach { view.addSubview($0) }
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(68)
            $0.left.equalToSuperview().inset(Const.padding)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.left.equalToSuperview().inset(Const.padding)
        }
        
        appleLoginBtn.snp.makeConstraints {
            $0.bottom.equalTo(nonLoginBtn.snp.top).offset(-20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Const.glBtnWidth)
            $0.height.equalTo(Const.glBtnHeight)
        }
        
        nonLoginBtn.snp.makeConstraints {
            $0.bottom.equalTo(termsOfServiceBtn.snp.top).offset(-57)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Const.glBtnWidth)
            $0.height.equalTo(Const.glBtnHeight)
        }
        
        termsOfServiceBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(32)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(170)
            $0.height.equalTo(20)
        }
    }
    
    func bind() {
        let output = viewModel.transform(input: LoginViewModel.Input(appleLoginBtnTap: appleLoginBtn.tapGesture,
                                                                     nonLoginBtnTap: nonLoginBtn.tapGesture,
                                                                     termsOfServiceBtnTap: termsOfServiceBtn.tapGesture))
        
        output.loginResult
            .emit(onNext: { [weak self] (result) in
                guard let self = self else { return }
                
                if result {
                    self.coordinator?.loginSuccess()
                } else {
                    self.coordinator?.moveToPersonalInfoPage()
                }
            })
            .disposed(by: disposeBag)
        
        kakaoLoginButton.rx.tap
            .bind(onNext: {
                self.coordinator?.loginSuccess()
            })
            .disposed(by: disposeBag)
    }
    
}
