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

class MyPageTagVC: UIViewController, SnapKitType {
 
    weak var coordinator: MyPageCoordinating?
    var disposeBag = DisposeBag()
    static let borderColor = UIColor(red: 241/255, green: 243/255, blue: 244/255, alpha:1)
    
    let navigationView = NavigationView(frame: .zero, type: .none).then {
        $0.logo.isHidden = true
        $0.backBtn.isHidden = false
        $0.title.isHidden = false
        $0.title.text = "나의 태그를 선택해주세요"
    }
    
    let tagStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
    }
    
    let ageTagView = TagView(frame: .zero, data: ["10대", "20대", "30대", "40대 이상", "50대 이상"]).then {
        $0.title.text = "나이"
    }
    
    let sexTagView = TagView(frame: .zero, data: ["남자", "여자"]).then {
        $0.title.text = "성별"
    }
    
    let jobTagView = TagView(frame: .zero, data: ["기획", "디자인", "서버", "클라이언트"]).then {
        $0.title.text = "직업"
    }
    
    let tagView = TagView(frame: .zero, data: ["편안한"]).then {
        $0.title.text = "원하는 대화 분위기"
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
        [navigationView, ageTagView, sexTagView, jobTagView, tagView].forEach { view.addSubview($0) }
        
    }
    
    func setConstraints() {
        navigationView.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        ageTagView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(160)
        }
        
        sexTagView.snp.makeConstraints {
            $0.top.equalTo(ageTagView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(113)
        }
        
        jobTagView.snp.makeConstraints {
            $0.top.equalTo(sexTagView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(113)
        }
        
        tagView.snp.makeConstraints {
            $0.top.equalTo(jobTagView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(113)
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
