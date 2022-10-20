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
    
    var mySpeaker: [MatchedSpeaker]?
    
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
    let mySpeakerView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
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

        [joinImg, joinLbl, mySpeakerView].forEach{
            containerView.addSubview($0)
        }
        
        mySpeakerView.register(mySpeakerCell.self, forCellWithReuseIdentifier: mySpeakerCell.identifier)
        mySpeakerView.dataSource = self
        mySpeakerView.delegate = self
   
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
        mySpeakerView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(5)
            $0.bottom.right.equalToSuperview().offset(-5)
        }
        
        callBtn.snp.makeConstraints {
            $0.width.equalTo(Const.glBtnWidth)
            $0.height.equalTo(Const.glBtnHeight)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        self.view.bringSubviewToFront(callBtn)
        
    }
    
    func bind() {
        callBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.call(model: self?.mySpeaker)
            })
            .disposed(by: disposeBag)
    }
    
 
    func changeUI(_ type: applicantState) {
        switch type {
        case .join:
            joinImg.isSkeletonable = true
            joinLbl.isSkeletonable = true
            joinImg.isHidden = false
            joinLbl.isHidden = false
            break
        case .matched:
            mySpeakerView.isHidden = false
            callBtn.isHidden = false
            break
        }
    }
    
    func initUI(){
        joinImg.isHidden = true
        joinLbl.isHidden = true
        mySpeakerView.isHidden = true
        callBtn.isHidden = true
        containerView.layer.borderColor = .none
    }
    
    func fetchData(){
        initUI()
        self.containerView.showAnimatedGradientSkeleton()
        MatchAPI.MatchedSpeaker { data, error in
            self.containerView.hideSkeleton()
            if ((data) != nil) {
                self.mySpeaker = data
                self.mySpeakerView.reloadData()
                self.applicantState = .matched
                self.changeUI(self.applicantState)
                
            } else {
                self.applicantState = .join
                self.changeUI(self.applicantState)
            }
        }
    }
}

extension ApplicantVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mySpeaker?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mySpeakerCell.identifier, for: indexPath) as? mySpeakerCell else {fatalError()}
        return cell
    }

}

extension ApplicantVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = mySpeakerView.frame.size.width
        let height = mySpeakerView.frame.size.height
        return CGSize(
            width: width,
            height: height
        )
    }
    
}
