//
//  ViewController.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/07/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa


class PersonalInfoVC: UIViewController, SnapKitType {
    
    weak var coordinator: LoginCoordinating?
    var disposeBag = DisposeBag()
    
    let titleLabel = UILabel().then {
        $0.text = "당신에 대해서 알려주세요"
        $0.textAlignment = .left
        $0.font = FontManager.shared.notoSansKR(.bold, 20)
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    let subtitleLabel = UILabel().then {
        $0.text = "리스너가 당신을 더 잘 이해할 수 있어요"
        $0.textColor = .f4
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
    }
    
    let nextButton = GLButton().then {
        $0.title = "다음"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addComponents()
        setConstraints()
        bind()
        view.backgroundColor = .white
    }
    
    func addComponents() {
        [titleLabel, subtitleLabel, nextButton].forEach { view.addSubview($0) }
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.width.equalTo(Const.glBtnWidth)
            $0.height.equalTo(Const.glBtnHeight)
            $0.centerX.equalToSuperview()
        }
    }
    
    func bind() {
        nextButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.coordinator?.moveToNicknameSetPage()
            })
            .disposed(by: disposeBag)
    }
    
}
