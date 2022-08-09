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
    var coordinator: CallCoordinating?
    
    let titleLabel = UILabel().then {
        $0.text = "후기 남기기"
        $0.textAlignment = .left
        $0.font = FontManager.shared.notoSansKR(.bold, 26)
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    let completeButton = GLButton().then {
        $0.title = "확인"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addComponents()
        setConstraints()
        bind()
        view.backgroundColor = .white
    }
    
    func addComponents() {
        [titleLabel, completeButton].forEach { view.addSubview($0) }
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(68)
            $0.left.equalToSuperview().inset(Const.padding)
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
