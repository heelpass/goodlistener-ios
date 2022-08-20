//
//  HomeViewController.swift
//  GoodListener
//
//  Created by cheonsong on 2022/07/26.
//

import UIKit
import RxSwift

// TODO: 신청 전, 매칭 후 2가지 상태 view 표시(enum)
enum homeState {
    case join
    case matched
}

class HomeVC: UIViewController, SnapKitType {

    weak var coordinator: HomeCoordinating?
    let disposeBag = DisposeBag()

    let scrollView = UIScrollView().then {
        $0.backgroundColor = .m6
    }
    
    let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .clear
    }
    
    let navigationView = NavigationView(frame: .zero, type: .notice)
    let titleLbl = UILabel().then {
        $0.text = "나의 리스너"
        $0.font = FontManager.shared.notoSansKR(.bold, 20)
    }
    
    let containerView = UIView().then {
        $0.backgroundColor = .m5
        $0.layer.cornerRadius = 20
    }
    
    let daycheckLbl = UILabel().then{
        $0.text = "7일 중 3일차"
        $0.font = FontManager.shared.notoSansKR(.bold, 20)
        $0.textColor = .f2
        $0.textAlignment = .center
    }
    
    let profileImg = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "person")
        $0.contentMode = .scaleAspectFill
    }
    
    
    let confirmBtn = GLButton().then {
        $0.title = "오늘 대화 미루기"
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .m6
        
        //TODO: 사용자 상태 값에 따라 나중에 바꾸기
        var homeState: homeState = .matched
        addComponents()
        setConstraints()
    }
    
    func addComponents() {
        view.addSubview(navigationView)
        view.addSubview(scrollView)
        view.addSubview(confirmBtn)
        navigationView.backgroundColor = .m6
        scrollView.addSubview(contentStackView)
        [titleLbl, containerView].forEach {
            contentStackView.addArrangedSubview($0)
        }
     
    }
    
    func setConstraints() {
        navigationView.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(35)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView).inset(UIEdgeInsets(top: 35, left: Const.padding, bottom: 0, right: Const.padding))
            $0.width.equalTo(scrollView.snp.width).offset(-Const.padding*2)
        }
        
        contentStackView.setCustomSpacing(20, after: titleLbl)
        containerView.snp.makeConstraints {
            //$0.height.equalTo(488)
           $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-108)
        }
  
        confirmBtn.snp.makeConstraints {
            $0.width.equalTo(Const.glBtnWidth)
            $0.height.equalTo(Const.glBtnHeight)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
       // self.view.bringSubviewToFront(confirmBtn)
        
    }
}

