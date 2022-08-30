//
//  MyPageTagVC.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/11.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MyPageModifyVC: UIViewController, SnapKitType {
 
    weak var coordinator: MyPageCoordinating?
    var disposeBag = DisposeBag()
    static let borderColor = UIColor(red: 241/255, green: 243/255, blue: 244/255, alpha:1)
    
    let navigationView = NavigationView(frame: .zero, type: .save).then {
        $0.logo.isHidden = true
        $0.backBtn.isHidden = false
        $0.title.isHidden = false
        $0.title.text = "나의 정보 수정"
    }
    
    lazy var jobTagView = TagView(data: TagList.jobList).then {
        $0.title.text = "하는 일"
        $0.selectedTag.accept(UserDefaultsManager.shared.job!)
        $0.line.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addComponents()
        setConstraints()
        bind()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func addComponents() {
        [navigationView, jobTagView].forEach { view.addSubview($0) }
    }
    
    func setConstraints() {
        navigationView.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        jobTagView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(64)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(jobTagView.tagCollectionViewHeight())
        }
    }
    
    func bind() {
        navigationView.backBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
