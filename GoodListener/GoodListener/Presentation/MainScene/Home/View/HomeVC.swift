//
//  HomeViewController.swift
//  GoodListener
//
//  Created by cheonsong on 2022/07/26.
//

import UIKit
import RxSwift

// TODO: 신청 전, 매칭 후 2가지 상태 view 표시(enum)
class HomeVC: UIViewController {
    
    weak var coordinator: HomeCoordinating?
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .m6
        let label = UILabel()
        label.text = "Home"
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }

}
