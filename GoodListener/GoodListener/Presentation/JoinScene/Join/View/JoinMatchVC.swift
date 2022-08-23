//
//  JoinMatchVC.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/08/21.
//

import UIKit
import RxSwift

enum JoinMatchState {
    case waiting
    case unable
    case matched
}

class JoinMatchVC: UIViewController, SnapKitType {
    
    weak var coordinator: JoinCoordinating?
    let disposeBag = DisposeBag()
    
    // 현재 매칭 화면 상태
    var joinMatchState: JoinMatchState = .unable
    
    let unableLbl = UILabel().then {
        $0.text = "죄송합니다"
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.bold, 20)
        $0.textColor = .f2
    }
    
    let unableSubLbl = UILabel().then {
        $0.text = "해당 시간에는 대화 가능한\n리스너가 없어요..."
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.bold, 20)
        $0.textColor = .f2
    }
    
    let unableImg = UIImageView().then{
        $0.image = #imageLiteral(resourceName: "main_img_impossible")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let unabledescriptionLbl = UILabel().then {
        $0.text = "다른 시간으로 리스너에게\n대화를 신청해 볼까요?"
        $0.numberOfLines = 0
        $0.sizeToFit()
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
        $0.textColor = .f4
    }
    
    let confirmBtn = GLButton().then {
        $0.title = "확인"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .m5
        addComponents()
        setConstraints()
        bind()
        changeUI(joinMatchState)
    }
    
    func addComponents() {
        [unableLbl, unableSubLbl, unableImg, unabledescriptionLbl, confirmBtn].forEach {
            view.addSubview($0)
        }
    }
    
    func setConstraints() {
        unableLbl.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(128)
            $0.centerX.equalToSuperview()
        }
        
        unableSubLbl.snp.makeConstraints{
            $0.top.equalTo(unableLbl.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        unableImg.snp.makeConstraints {
            $0.top.equalTo(unableSubLbl.snp.bottom).offset(33)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        unabledescriptionLbl.snp.makeConstraints {
            $0.top.equalTo(unableImg.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        confirmBtn.snp.makeConstraints {
            $0.width.equalTo(Const.glBtnWidth)
            $0.height.equalTo(Const.glBtnHeight)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
    }
    
    func bind() {
        confirmBtn.rx.tap
            .bind(onNext: { [weak self] in
                self?.coordinator?.moveToHome()
            })
            .disposed(by: disposeBag)
    }
    
    func changeUI(_ type: JoinMatchState) {
        switch type {
        case  .waiting:
            break
        case .unable:
            unableLbl.isHidden = false
            unableSubLbl.isHidden = false
            unableImg.isHidden = false
            unabledescriptionLbl.isHidden = false
            confirmBtn.isHidden = false
            break
        case .matched:
            break
        }
    }
}
