//
//  ReviewVC.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/09.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa



class CallReviewVC: UIViewController, SnapKitType {
    
    var disposeBag = DisposeBag()
    weak var coordinator: CallCoordinating?
    
    let titleLabel = UILabel().then {
        $0.text = "후기 남기기"
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.bold, 20)
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    let completeButton = GLButton().then {
        $0.title = "확인"
    }
    
    let moodContainer = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let moodTitle = UILabel().then {
        $0.text = "오늘 대화는 어땠나요?"
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    let moodView = MoodView()

    override func viewDidLoad() {
        super.viewDidLoad()
        addComponents()
        setConstraints()
        bind()
        view.backgroundColor = .white
    }
    
    func addComponents() {
        [titleLabel, moodTitle, moodView, completeButton].forEach { view.addSubview($0) }
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.centerX.equalToSuperview()
        }
        
        moodTitle.snp.makeConstraints {
            $0.top.equalTo(titleLabel).offset(52)
            $0.left.right.equalToSuperview().inset(Const.padding)
        }
        
        moodView.snp.makeConstraints {
            $0.top.equalTo(moodTitle.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(moodView.moodCollectionViewWidth())
            $0.height.equalTo(86)
        }
        
        completeButton.snp.makeConstraints {
            $0.width.equalTo(Const.glBtnWidth)
            $0.height.equalTo(Const.glBtnHeight)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(50)
        }
    }
    
    func bind() {
        completeButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.coordinator?.moveToMain()
            })
            .disposed(by: disposeBag)
    }
}
