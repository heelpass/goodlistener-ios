//
//  NoticeVC.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/09/02.
//

import UIKit
import RxSwift

enum noticeState {
    case none
    case notice
}


class NoticeVC: UIViewController, SnapKitType {
    
    weak var coordinator: HomeCoordinating?
    let disposeBag = DisposeBag()
    
    var noticeState: noticeState = .none
    
    let navigationView = NavigationView(frame: .zero, type: .none).then {
        $0.logo.isHidden = true
        $0.backBtn.isHidden = false
        $0.title.isHidden = false
        $0.title.text = "알림"
    }

    let bellImg = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "img_noti_no")
        $0.contentMode = .scaleAspectFill
    }
    
    let nonetitleLbl = UILabel().then {
        $0.text = "알림이 없어요"
        $0.textColor = .f4
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
    }
    
    let noneContentLbl = UILabel().then {
        $0.text = "알림을 설정하고 알림을 받아 보세요"
        $0.textColor = .f4
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
    }
    
    let noneSettingLbl = UILabel().then {
        $0.text = "알림 설정하기"
        $0.textColor = .m1
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addComponents()
        setConstraints()
        bind()
        changeUI(noticeState)
    }
    
    func addComponents() {
        [navigationView, bellImg, nonetitleLbl, noneContentLbl, noneSettingLbl].forEach{
            view.addSubview($0)
        }
    }
    
    func setConstraints() {
        navigationView.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        bellImg.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom).offset(113)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        nonetitleLbl.snp.makeConstraints{
            $0.top.equalTo(bellImg.snp.bottom).offset(27)
            $0.centerX.equalToSuperview()
        }
        
        noneContentLbl.snp.makeConstraints{
            $0.top.equalTo(nonetitleLbl.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        noneSettingLbl.snp.makeConstraints{
            $0.top.equalTo(noneContentLbl.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    func bind() {
        navigationView.backBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
        .disposed(by: disposeBag)
    }

    func changeUI(_ type: noticeState) {
        switch type {
        case .none:
            bellImg.isHidden = false
            nonetitleLbl.isHidden = false
            noneContentLbl.isHidden = false
            noneSettingLbl.isHidden = false
            break
        case .notice:
            bellImg.isHidden = true
            nonetitleLbl.isHidden = true
            noneContentLbl.isHidden = true
            noneSettingLbl.isHidden = true
            break
        }
    }
}
