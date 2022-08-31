//
//  DeleteAccountView.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/30.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class DeleteAccountVC: UIViewController, SnapKitType {
    
    weak var coordinator: MyPageCoordinating?
    let viewModel = DeleteAccountViewModel()
    let disposeBag = DisposeBag()
    
    var deleteAccountObservable = PublishRelay<Void>()
    
    let navigationView = NavigationView(frame: .zero, type: .none)
    
    let titleLbl = UILabel().then {
        $0.text = "정말 탈퇴하시나요?"
        $0.font = FontManager.shared.notoSansKR(.bold, 18)
        $0.textColor = .f2
        $0.sizeToFit()
    }
    
    let line1 = UIView().then {
        $0.backgroundColor = .l2
    }
    
    let subtitleIco = UIImageView().then {
        $0.image = UIImage(named: "ico_exclamation")
    }
    
    let subtitleLbl = UILabel().then {
        $0.text = "탈퇴 안내 및 유의사항"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f3
        $0.sizeToFit()
    }
    
    let description1 = UILabel().then {
        $0.text = "탈퇴 후 동일한 이메일, 아이디로 다시 가입하여도 데이터들을 불러올 수 없습니다."
        $0.font = FontManager.shared.notoSansKR(.regular, 15)
        $0.textColor = .f4
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    let description2 = UILabel().then {
        $0.text = "• 내 프로필 정보\n• 닉네임, 성향, 나이, 성별\n• 대화한 사용자 정보\n• 나의 대화 내용, 대화 온도 내역\n• 그 외에 사용자가 설정한 모든 정보"
        $0.font = FontManager.shared.notoSansKR(.regular, 15)
        $0.textColor = .f4
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    let line2 = UIView().then {
        $0.backgroundColor = .l1
    }
    
    let checkboxContainer = UIView().then {
        $0.backgroundColor = .clear
    }
    let checkbox = CheckBox()
    
    let checkboxLbl = UILabel().then {
        $0.text = "위 내용에 동의합니다."
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f4
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = .clear
        $0.spacing = 15
        $0.distribution = .fillEqually
    }
    
    let noBtn = UIButton().then {
        $0.layer.cornerRadius = 4
        $0.layer.borderColor = UIColor.f6.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .white
        $0.title = "더 사용해볼래요"
        $0.titleColor = .f3
        $0.font = FontManager.shared.notoSansKR(.regular, 15)
    }
    
    let yesBtn = GLButton(type: .rectangle, reverse: false).then {
        $0.title = "네, 탈퇴할게요"
        $0.font = FontManager.shared.notoSansKR(.regular, 15)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addComponents()
        setConstraints()
        bind()
    }
    
    func addComponents() {
        [navigationView, titleLbl, line1, subtitleIco, subtitleLbl, description1, description2, line2, checkboxContainer, buttonStackView].forEach { view.addSubview($0) }
        [checkbox, checkboxLbl].forEach { checkboxContainer.addSubview($0) }
        [noBtn, yesBtn].forEach { buttonStackView.addArrangedSubview($0) }
        
    }
    
    func setConstraints() {
        navigationView.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        titleLbl.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(35)
            $0.left.equalToSuperview().inset(Const.padding)
        }
        
        line1.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(8)
            $0.top.equalTo(titleLbl.snp.bottom).offset(31)
        }
        
        subtitleIco.snp.makeConstraints {
            $0.left.equalToSuperview().inset(Const.padding)
            $0.top.equalTo(line1.snp.bottom).offset(34)
            $0.size.equalTo(20)
        }
        
        subtitleLbl.snp.makeConstraints {
            $0.left.equalTo(subtitleIco.snp.right).offset(10)
            $0.centerY.equalTo(subtitleIco)
        }
        
        description1.snp.makeConstraints {
            $0.top.equalTo(subtitleIco.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(Const.padding)
        }
        
        description2.snp.makeConstraints {
            $0.top.equalTo(description1.snp.bottom).offset(25)
            $0.left.right.equalToSuperview().inset(Const.padding)
        }
        
        line2.snp.makeConstraints {
            $0.top.equalTo(description2.snp.bottom).offset(28)
            $0.height.equalTo(1)
            $0.left.right.equalToSuperview()
        }
        
        checkboxContainer.snp.makeConstraints {
            $0.top.equalTo(line2.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        checkbox.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
        }
        
        checkboxLbl.snp.makeConstraints {
            $0.left.equalTo(checkbox.snp.right).offset(8)
            $0.right.equalToSuperview()
            $0.centerY.equalTo(checkbox)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview().inset(Const.padding)
            $0.height.equalTo(Const.glBtnHeight)
        }
    }
    
    func bind() {
        let output = viewModel.transform(input: DeleteAccountViewModel.Input(checkboxSeledted: checkbox.selected.asObservable(),
                                                                             yesBtnTap: yesBtn.rx.tap.asObservable(),
                                                                             deleteAccount: deleteAccountObservable.asObservable()))
        
        // 팝업 메세지 출력
        output.popupMessage
            .emit(onNext: { [weak self] message in
                guard let self = self else { return }
                
                let popup = GLPopup()
                popup.title = "알림"
                popup.contents = message
                // 회원 탈퇴 메세지일 경우 완료버튼 액션을 추가해줘야한다
                // 완료버튼 -> 회원탈퇴 로직 타야함
                if message == PopupMessage.deleteAccount {
                    popup.completeAction = {
                        self.deleteAccountObservable.accept(())
                    }
                } else {
                    popup.cancelIsHidden = true
                }
                self.view.addSubview(popup)
                popup.snp.makeConstraints {
                    $0.width.equalTo(UIScreen.main.bounds.width)
                    $0.height.equalTo(UIScreen.main.bounds.height)
                    $0.center.equalToSuperview()
                }
            })
            .disposed(by: disposeBag)
        
        output.deleteAccountResult
            .emit(onNext: { [weak self] result in
                UserDefaultsManager.shared.logout()
                self?.coordinator?.deleteAccountSuccess()
            })
            .disposed(by: disposeBag)
        
        noBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
