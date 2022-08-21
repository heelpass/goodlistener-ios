//
//  JoinVC.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/08/21.
//

import UIKit
import RxSwift

class JoinVC: UIViewController {

    weak var coordinator: JoinCoordinating?
    let disposeBag = DisposeBag()
    
    let waitingBtn = GLButton().then {
        $0.title = "대기 화면으로 이동"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        
        view.addSubview(waitingBtn)
        waitingBtn.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        waitingBtn.tapGesture
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.moveToJoinMatch()
            })
            .disposed(by: disposeBag)
    }

}
