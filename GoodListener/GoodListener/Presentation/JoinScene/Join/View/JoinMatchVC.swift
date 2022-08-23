//
//  JoinMatchVC.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/08/21.
//

import UIKit
import RxSwift

class JoinMatchVC: UIViewController {
    
    weak var coordinator: JoinCoordinating?
    let disposeBag = DisposeBag()
    
    let comebackHomeBtn = GLButton().then {
        $0.title = "홈 화면으로 이동"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        
        view.addSubview(comebackHomeBtn)
        comebackHomeBtn.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
//
        comebackHomeBtn.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.coordinator?.moveToHome()
            })
            .disposed(by: disposeBag)
 
    }
}
