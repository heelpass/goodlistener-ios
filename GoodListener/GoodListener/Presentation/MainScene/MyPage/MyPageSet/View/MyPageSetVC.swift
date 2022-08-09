//
//  MyPageSetVC.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/09.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Then

class MyPageSetVC: UIViewController, SnapKitType {

    weak var coordinator: MyPageCoordinating?
    var disposeBag = DisposeBag()
    static let borderColor = UIColor(red: 241/255, green: 243/255, blue: 244/255, alpha:1)
    let titleLabel = UILabel().then {
        $0.text = "설정"
        $0.font = FontManager.shared.notoSansKR(.bold, 26)
        $0.textColor = .f2
    }
    
    let navigationView = NavigationView(frame: .zero, type: .save)
    
    let line = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.9592439532, green: 0.9656613469, blue: 0.9688369632, alpha: 1)
    }
    
    let stackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
    }
    
    let talkContainer = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.addBorder([.bottom], color: borderColor, width: 0.5)
    }
    
    let talkTitleLabel = UILabel().then {
        $0.text = "대화 알림"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f3
    }
    
    let talkSubtitle = UILabel().then {
        if UIScreen.main.bounds.width > 375 {
            $0.text = "알림을 해제하면 통화 알림을 받을 수 없어요"
        } else {
            $0.text = "알림을 해제하면 통화 알림을 받을 수\n없어요"
        }
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f5
        $0.numberOfLines = 2
    }
    
    let talkSwitch = UISwitch().then {
        $0.tintColor = .m1
    }
    
    let remindContainer = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.addBorder([.top, .bottom], color: borderColor, width: 0.5)
    }
    
    let remindTitleLabel = UILabel().then {
        $0.text = "리마인드 알림"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f3
    }
    
    let remindSubtitle = UILabel().then {
        if UIScreen.main.bounds.width > 375 {
            $0.text = "통화시간 관련 리마인드 알림을 받을 수 있어요"
        } else {
            $0.text = "통화시간 관련 리마인드 알림을 받을 수\n있어요"
        }
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f5
        $0.numberOfLines = 2
    }
    
    let remindSwitch = UISwitch().then {
        $0.tintColor = .m1
    }
    
    let marketingContainer = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.addBorder([.top], color: borderColor, width: 0.5)
    }
    
    let marketingTitleLabel = UILabel().then {
        $0.text = "마케팅 푸시 알림"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f3
    }
    
    let marketingSubtitle = UILabel().then {
        if UIScreen.main.bounds.width > 375 {
            $0.text = "혜택 소식 알림을 받을 수 있어요"
        } else {
            $0.text = "혜택 소식 알림을 받을 수\n있어요"
        }
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f5
        $0.numberOfLines = 2
    }
    
    let marketingSwitch = UISwitch().then {
        $0.tintColor = .m1
    }
    
    let line2 = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.9592439532, green: 0.9656613469, blue: 0.9688369632, alpha: 1)
    }
    
    let logoutContainer = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.addBorder([.bottom], color: borderColor, width: 0.5)
    }
    
    let logoutLabel = UILabel().then {
        $0.text = "로그아웃"
        $0.textColor = .f3
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
    }
    
    let withdrawContainer = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.addBorder([.top], color: borderColor, width: 0.5)
    }
    
    let withdrawLabel = UILabel().then {
        $0.text = "탈퇴하기"
        $0.textColor = .f3
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addComponents()
        setConstraints()
        bind()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        // Do any additional setup after loading the view.
    }
    
    func addComponents() {
        [navigationView, titleLabel, stackView].forEach { view.addSubview($0) }
        [line, talkContainer, remindContainer, marketingContainer, line2, logoutContainer, withdrawContainer].forEach( { stackView.addArrangedSubview($0) } )
        [talkTitleLabel, talkSubtitle, talkSwitch].forEach { talkContainer.addSubview($0) }
        [remindTitleLabel, remindSubtitle, remindSwitch].forEach { remindContainer.addSubview($0) }
        [marketingTitleLabel, marketingSubtitle, marketingSwitch].forEach { marketingContainer.addSubview($0) }
        logoutContainer.addSubview(logoutLabel)
        withdrawContainer.addSubview(withdrawLabel)
    }
    
    func setConstraints() {
        navigationView.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(35)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(32)
            $0.left.equalToSuperview().inset(Const.padding)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.left.right.equalToSuperview()
        }
        
        line.snp.makeConstraints {
            $0.height.equalTo(8)
        }
        
        line2.snp.makeConstraints {
            $0.height.equalTo(8)
        }
        
        talkTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.left.equalToSuperview().inset(Const.padding)
        }
        
        talkSubtitle.snp.makeConstraints {
            $0.top.equalTo(talkTitleLabel.snp.bottom).offset(5)
            $0.left.equalToSuperview().inset(Const.padding)
            $0.bottom.equalToSuperview().inset(17)
            $0.width.greaterThanOrEqualTo(250)
        }
        
        talkSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(Const.padding)
            $0.left.equalTo(talkSubtitle.snp.right).offset(16)
        }
        
        remindTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.left.equalToSuperview().inset(Const.padding)
        }
        
        remindSubtitle.snp.makeConstraints {
            $0.top.equalTo(remindTitleLabel.snp.bottom).offset(5)
            $0.left.equalToSuperview().inset(Const.padding)
            $0.bottom.equalToSuperview().inset(17)
            $0.width.greaterThanOrEqualTo(250)
        }
        
        remindSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(Const.padding)
            $0.left.equalTo(remindSubtitle.snp.right).offset(16)
        }
        
        marketingTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.left.equalToSuperview().inset(Const.padding)
        }
        
        marketingSubtitle.snp.makeConstraints {
            $0.top.equalTo(marketingTitleLabel.snp.bottom).offset(5)
            $0.left.equalToSuperview().inset(Const.padding)
            $0.bottom.equalToSuperview().inset(17)
            $0.width.greaterThanOrEqualTo(250)
        }
        
        marketingSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(marketingSubtitle.snp.right).offset(16)
            $0.right.equalToSuperview().inset(Const.padding)
        }
        
        logoutContainer.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        logoutLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(Const.padding)
            $0.centerY.equalToSuperview()
        }
        
        withdrawContainer.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        withdrawLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(Const.padding)
            $0.centerY.equalToSuperview()
        }
        
    }
    
    func bind() {
        logoutContainer.tapGesture
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.logout()
            })
            .disposed(by: disposeBag)
    }

}
