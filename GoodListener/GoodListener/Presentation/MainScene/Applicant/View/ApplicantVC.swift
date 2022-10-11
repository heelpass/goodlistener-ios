//
//  ApplicantViewController.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/07/26.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView

enum applicantState{
    case join
    case matched
}

class ApplicantVC: UIViewController, SnapKitType {

    weak var coordinator: ApplicantCoordinating?
    let disposeBag = DisposeBag()
    
    let navigationView = NavigationView(frame: .zero, type: .notice)
    let scrollView = UIScrollView()
    
    //현재 리스너 홈 화면 상태
    var applicantState: applicantState = .matched
    
    let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .clear
    }
    
    let titleLbl = UILabel().then {
        $0.text = "당신의 스피커"
        $0.font = FontManager.shared.notoSansKR(.bold, 20)
    }
    
    let containerView = UIView().then {
        $0.layer.cornerRadius = 20
    }
    
    //신청 전 화면 UI 요소
    let joinImg = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "main_img_notalk")
    }
    
    let joinLbl = UILabel().then {
        $0.text = "아직 진행 중인 대화가 없어요.\n지금 바로 대화를 신청해 보세요"
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = .f4
    }
    
    //매칭 완료 후 UI 요소
    let mySpeakerCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.layer.cornerRadius = 20
        return view
    }()
    
    let callBtn = GLButton().then {
        $0.title = "전화 걸기"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .m5
        addComponents()
        setConstraints()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initUI()
        fetchData()
    }
    

    func addComponents() {
        [navigationView, scrollView, callBtn].forEach{
            view.addSubview($0)
        }
        scrollView.addSubview(contentStackView)
        [titleLbl, containerView].forEach{
            contentStackView.addArrangedSubview($0)
        }

        [joinImg, joinLbl, mySpeakerCollectionView].forEach{
            containerView.addSubview($0)
        }

    }
    
    func setConstraints() {
        navigationView.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(35)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView).inset(UIEdgeInsets(top: 35, left: Const.padding, bottom: 100, right: Const.padding))
            $0.width.equalTo(scrollView.snp.width).offset(-Const.padding*2)
        }
        
        contentStackView.setCustomSpacing(20, after: titleLbl)
        
        containerView.snp.makeConstraints {
            $0.height.equalTo(488)
        }
        
        // 신청 전 UI
        joinImg.snp.makeConstraints{
            $0.top.equalToSuperview().offset(139)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }
        joinLbl.snp.makeConstraints{
            $0.top.equalTo(joinImg.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        // 매칭 후 UI
        mySpeakerCollectionView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        callBtn.snp.makeConstraints {
            $0.width.equalTo(Const.glBtnWidth)
            $0.height.equalTo(Const.glBtnHeight)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        self.view.bringSubviewToFront(callBtn)
        
    }
    
    func bind() {}
    
 
    func changeUI(_ type: applicantState) {
        switch type {
        case .join:
            joinImg.isHidden = false
            joinLbl.isHidden = false
            break
        case .matched:
            mySpeakerCollectionView.isHidden = false
            callBtn.isHidden = false
            containerView.backgroundColor = .white
            containerView.layer.borderColor = UIColor(hex: "#B1B3B5").cgColor
            containerView.layer.applySketchShadow(color: UIColor(hex: "#B1B3B5"), alpha: 0.7, x: 0, y: 0, blur: 15, spread: 0)
            break
        }
    }
    
    func initUI(){
        joinImg.isHidden = true
        joinLbl.isHidden = true
        mySpeakerCollectionView.isHidden = true
        callBtn.isHidden = true
        containerView.layer.borderColor = .none
    }
    
    func fetchData(){
        self.changeUI(.matched)
    }

}
