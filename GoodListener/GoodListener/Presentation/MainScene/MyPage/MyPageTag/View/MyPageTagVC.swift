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
    
    var ageList = ["10대", "20대", "30대", "40대 이상", "50대 이상"]
    var sexList = ["남자", "여자"]
    var jobList = ["기획", "디자인", "서버", "클라이언트"]
    
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
    
    lazy var ageTagView = TagView(frame: .zero, data: ageList).then {
        $0.title.text = "나이"
    }
    
    lazy var sexTagView = TagView(frame: .zero, data: sexList).then {
        $0.title.text = "성별"
    }
    
    lazy var jobTagView = TagView(frame: .zero, data: jobList).then {
        $0.title.text = "직업"
    }
    
    lazy var tagView = TagView(frame: .zero, data: ["편안한", "잔인한", "행복한", "즐거운", "무서운"]).then {
        $0.title.text = "원하는 대화 분위기"
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
            $0.height.equalTo(tagCollectionViewHeight(list: ageList))
        }
        
        sexTagView.snp.makeConstraints {
            $0.top.equalTo(ageTagView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(tagCollectionViewHeight(list: sexList))
        }
        
        jobTagView.snp.makeConstraints {
            $0.top.equalTo(sexTagView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(tagCollectionViewHeight(list: jobList))
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
    
    func tagCollectionViewHeight(list: [String])-> CGFloat {
        let spacing: CGFloat = 8
        var totalCellWidth: CGFloat = Const.padding * 2
        let cellSpacing: CGFloat = 32
        let screenWidth = UIScreen.main.bounds.width
        var height: CGFloat = 113
        
        list.forEach { (text) in
            let label = UILabel()
            label.text = text
            label.font = FontManager.shared.notoSansKR(.bold, 14)
            label.sizeToFit()
            Log.d("Text:: \(text)")
            totalCellWidth += (label.frame.width + cellSpacing)
            if totalCellWidth + spacing < screenWidth {
                totalCellWidth += spacing
            } else {
                Log.d("TextPlus:: \(text)")
                height += (38 + spacing)
                totalCellWidth = Const.padding * 2
            }
        }

        return height
    }
}
