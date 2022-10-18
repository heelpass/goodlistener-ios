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
    
    var signInModel = SignInModel()
    
    let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "우리,\n같이 마음 편하게\n이야기해볼까요?"
        $0.textAlignment = .left
        $0.font = FontManager.shared.notoSansKR(.bold, 32)
        $0.numberOfLines = 0
        $0.sizeToFit()
        $0.textColorChange(text: "우리,\n같이 마음 편하게\n이야기해볼까요?", color: .m1, range: ["마음 편하게\n이야기"])
    }
    
    let subtitleLabel = UILabel().then {
        $0.text = "내 마음 건강을 위한 매일 3분 보이스 루틴"
        $0.textColor = .white
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
    }
    
    let buttonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
        $0.distribution = .fillEqually
    }
    
    let appleLoginBtn = UIButton().then {
        $0.backgroundColor = .white
        $0.setImage(UIImage(named: "appleLogoB"), for: .normal)
        $0.title = "Apple 로그인"
        $0.titleColor = .f2
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.contentHorizontalAlignment = .center
        $0.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10) //<- 중요
        $0.layer.cornerRadius = 24
    }
    
    let guestLoginBtn = GLButton().then{
        $0.title = "게스트로 둘러보기"
        $0.contentHorizontalAlignment = .center
    }
    
    let termsOfServiceBtn = UILabel().then {
        $0.text = "필수 약관은 각 항목을 클릭하면 확인하실 수 있습니다."
        $0.textColor = .white
        $0.font = FontManager.shared.notoSansKR(.regular, 12)
        $0.backgroundColor = .clear
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.sizeToFit()
    }
    
    let termsOfServiceStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.spacing = 2
        $0.axis = .horizontal
    }
    
    let termsOfService = UILabel().then {
        $0.text = "이용약관"
        $0.textColor = .white
        $0.font = FontManager.shared.notoSansKR(.regular, 12)
        $0.backgroundColor = .clear
        $0.textUnderLine(text: "이용약관", range: ["이용약관"])
    }
    
    let termsOfService2 = UILabel().then {
        $0.text = "및"
        $0.textColor = .white
        $0.font = FontManager.shared.notoSansKR(.regular, 12)
        $0.backgroundColor = .clear
    }
    
    let termsOfService3 = UILabel().then {
        $0.text = "개인정보 취급 방침"
        $0.textColor = .white
        $0.font = FontManager.shared.notoSansKR(.regular, 12)
        $0.backgroundColor = .clear
        $0.textUnderLine(text: "개인정보 취급 방침", range: ["개인정보 취급 방침"])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addComponents()
        setConstraints()
        bind()
        view.backgroundColor = #colorLiteral(red: 0.1971904635, green: 0.2260227799, blue: 0.1979919374, alpha: 1)
    }

    func addComponents() {
        [titleLabel, subtitleLabel, buttonStackView, termsOfServiceBtn, termsOfServiceStackView].forEach { view.addSubview($0) }
        [appleLoginBtn, guestLoginBtn].forEach { buttonStackView.addArrangedSubview($0) }
        [termsOfService, termsOfService2, termsOfService3].forEach { termsOfServiceStackView.addArrangedSubview($0) }
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
        
        buttonStackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(Const.padding)
            $0.bottom.equalTo(termsOfServiceBtn.snp.top).offset(-39)
        }
        
        appleLoginBtn.snp.makeConstraints {
            $0.height.equalTo(Const.glBtnHeight)
        }
        
        guestLoginBtn.snp.makeConstraints {
            $0.height.equalTo(Const.glBtnHeight)
        }
        
        termsOfServiceBtn.snp.makeConstraints {
            $0.bottom.equalTo(termsOfServiceStackView.snp.top)
            $0.centerX.equalToSuperview()
        }
        
        termsOfServiceStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(32)
            $0.centerX.equalToSuperview()
        }
    }
    
    func bind() {
        let output = viewModel.transform(input: LoginViewModel.Input(appleLoginBtnTap: appleLoginBtn.tapGesture,
                                                                     nonLoginBtnTap: guestLoginBtn.tapGesture,
                                                                     termsOfServiceBtnTap: termsOfServiceBtn.tapGesture))
        
        output.loginResult
            .emit(onNext: { [weak self] (result) in
                guard let self = self else { return }
                
                if result {
                    self.coordinator?.loginSuccess()
                } else {
                    self.coordinator?.moveToPersonalInfoPage(model: self.signInModel)
                }
            })
            .disposed(by: disposeBag)
        
        
        termsOfService.tapGesture
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let popup = TermsOfServicePopup()
                popup.type = .termsOfService
                popup.configUI()
                self.view.addSubview(popup)
                popup.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
            })
            .disposed(by: disposeBag)
        
        termsOfService3.tapGesture
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let popup = TermsOfServicePopup()
                popup.type = .PersonalInformation
                popup.configUI()
                self.view.addSubview(popup)
                popup.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
            })
            .disposed(by: disposeBag)
    }
}
