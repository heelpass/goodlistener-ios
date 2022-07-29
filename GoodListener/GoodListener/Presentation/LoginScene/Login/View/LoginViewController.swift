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

class LoginViewController: UIViewController, SnapKitType {
    
    weak var coordinator: LoginCoordinating?
    var viewModel = LoginViewModel()
    var disposeBag = DisposeBag()
    
    let titleLabel = UILabel().then {
        $0.text = "우리, 같이 마음 편히\n얘기해볼까요?"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    let subtitleLabel = UILabel().then {
        $0.text = "내 마음 건강을 위한 매일 3분 보이스 루틴"
    }
    
    let appleLoginButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addComponents()
        setConstraints()
        bind()
        view.backgroundColor = .white
    }

    func addComponents() {
        [titleLabel, subtitleLabel, appleLoginButton].forEach { view.addSubview($0) }
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(200)
            $0.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(200)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(55)
        }
    }
    
    func bind() {
        let output = viewModel.transform(input: LoginViewModel.Input(appleLoginBtnTap: appleLoginButton.tapGesture))
        
        output.appleLoginResult
            .emit(onNext: { [weak self] (result) in
                guard let self = self else { return }
                
                if result {
                    self.coordinator?.loginSuccess()
                } else {
                    self.coordinator?.moveToAuthCheck()
                }
            })
            .disposed(by: disposeBag)
    }
}
