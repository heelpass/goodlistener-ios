//
//  NoticeVC.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/09/02.
//

import UIKit
import RxSwift

class NoticeVC: UIViewController, SnapKitType {
    
    weak var coordinator: HomeCoordinating?
    let disposeBag = DisposeBag()
    
    let navigationView = NavigationView(frame: .zero, type: .none).then {
        $0.logo.isHidden = true
        $0.backBtn.isHidden = false
        $0.title.isHidden = false
        $0.title.text = "알림"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addComponents()
        setConstraints()
        bind()
    }
    
    func addComponents() {
        view.addSubview(navigationView)
    }
    
    func setConstraints() {
        navigationView.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
    }
    
    func bind() {
        navigationView.backBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
        .disposed(by: disposeBag)
    }
}
