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
    
    let navigationView = NavigationView(frame: .zero, type: .none).then {
        $0.logo.isHidden = true
        $0.backBtn.isHidden = false
        $0.title.isHidden = false
        $0.title.text = "설정"
    }
    
    let stackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
    }
    
    let alarmSetContainer = UIView().then {
        $0.backgroundColor = .white
    }
    
    let alarmSetTitle = UILabel().then {
        $0.text = "대화 알림"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f3
        $0.sizeToFit()
    }
    
    let alarmSetSubtitle = UILabel().then {
        $0.text = "알림을 해제하면 통화 알림을 받을 수 없어요"
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f5
    }
    
    let alarmSetBtn = GLButton(type: .round, reverse: false).then {
        $0.title = "알림 해제하기"
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
    // 8
    let line = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.9592439532, green: 0.9656613469, blue: 0.9688369632, alpha: 1)
    }
    
    let line2 = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.9592439532, green: 0.9656613469, blue: 0.9688369632, alpha: 1)
    }
    
    //1
    let line3 = UIView().then {
        $0.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 1)
        $0.backgroundColor = borderColor
    }
    
    let line4 = UIView().then {
        $0.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 1)
        $0.backgroundColor = borderColor
    }
    
    let line5 = UIView().then {
        $0.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 1)
        $0.backgroundColor = borderColor
    }
    
    let versionContainer = UIView().then {
        $0.backgroundColor = UIColor(hex: "#F2F4F5")
    }
    
    let versionLbl = UILabel().then {
        $0.text = "앱 버전 1.0.0"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f5
    }
    
    let isUpdateLbl = UILabel().then {
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addComponents()
        setConstraints()
        bind()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        // Do any additional setup after loading the view.
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        if let version = version {
            versionLbl.text = "앱 버전 \(version)"
        }
        isUpdateLbl.text = UIApplication.isUpdateAvailable() ? "업데이트가 가능합니다." : "최신 버전입니다."
    }
    
    func addComponents() {
        [navigationView, stackView, versionContainer].forEach { view.addSubview($0) }
        [line, alarmSetContainer, line2, logoutContainer, line5, withdrawContainer].forEach( { stackView.addArrangedSubview($0) } )
        [alarmSetTitle, alarmSetSubtitle, alarmSetBtn].forEach { alarmSetContainer.addSubview($0) }
        logoutContainer.addSubview(logoutLabel)
        withdrawContainer.addSubview(withdrawLabel)
        versionContainer.addSubview(versionLbl)
        versionContainer.addSubview(isUpdateLbl)
    }
    
    func setConstraints() {
        navigationView.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.left.right.equalToSuperview()
        }
        
        alarmSetTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.left.equalToSuperview().inset(Const.padding)
        }
        
        alarmSetSubtitle.snp.makeConstraints {
            $0.top.equalTo(alarmSetTitle.snp.bottom).offset(4)
            $0.left.equalToSuperview().inset(Const.padding)
        }
        
        alarmSetBtn.snp.makeConstraints {
            $0.top.equalTo(alarmSetSubtitle.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(Const.padding)
            $0.height.equalTo(Const.glBtnHeight)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        line.snp.makeConstraints {
            $0.height.equalTo(8)
        }
        
        line2.snp.makeConstraints {
            $0.height.equalTo(8)
        }
        
        logoutContainer.snp.makeConstraints {
            $0.height.equalTo(64)
        }
        
        logoutLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(Const.padding)
            $0.centerY.equalToSuperview()
        }
        
        withdrawContainer.snp.makeConstraints {
            $0.height.equalTo(64)
        }
        
        withdrawLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(Const.padding)
            $0.centerY.equalToSuperview()
        }
        
        line3.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        line4.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        line5.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        versionContainer.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        versionLbl.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.centerX.equalToSuperview()
        }
        
        isUpdateLbl.snp.makeConstraints {
            $0.top.equalTo(versionLbl.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
    }
    
    func bind() {
        logoutContainer.tapGesture
            .subscribe(onNext: { [weak self] _ in
                if UserDefaultsManager.shared.isGuest {
                    self?.coordinator?.logout()
                    UserDefaultsManager.shared.logout()
                }
                
                let popup = GLPopup()
                popup.title = "알림"
                popup.contents = PopupMessage.logout
                popup.completeAction = {
                    self?.coordinator?.logout()
                    UserDefaultsManager.shared.logout()
                }
                self?.tabBarController?.view.addSubview(popup)
                popup.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
            })
            .disposed(by: disposeBag)
        
        withdrawContainer.tapGesture
            .subscribe(onNext: { [weak self] _ in
                if UserDefaultsManager.shared.isGuest {
                    let popup = GLPopup()
                    popup.title = "알림"
                    popup.contents = "로그인 후 이용해주세요"
                    popup.cancelIsHidden = true
                    popup.alignment = .center
                    
                    self?.view.addSubview(popup)
                    popup.snp.makeConstraints {
                        $0.edges.equalToSuperview()
                    }
                    
                    return
                }
                self?.coordinator?.moveToDeleteAccountPage()
            })
            .disposed(by: disposeBag)
        
        navigationView.backBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        alarmSetBtn.rx.tap
            .subscribe(onNext: {
                //"prefs:root=NOTIFICATIONS_ID"
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
            .disposed(by: disposeBag)
    }
}
