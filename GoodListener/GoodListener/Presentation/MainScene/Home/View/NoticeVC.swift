//
//  NoticeVC.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/09/02.
//

import UIKit
import RxSwift

enum noticeState {
    case none
    case notice
}

class NoticeVC: UIViewController, SnapKitType {
    
    weak var coordinator: HomeCoordinating?
    let disposeBag = DisposeBag()
    
    var noticeState: noticeState = .notice
    
    let navigationView = NavigationView(frame: .zero, type: .none).then {
        $0.logo.isHidden = true
        $0.backBtn.isHidden = false
        $0.title.isHidden = false
        $0.title.text = "알림"
    }

    let bellImg = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "img_noti_no")
        $0.contentMode = .scaleAspectFill
    }
    
    let nonetitleLbl = UILabel().then {
        $0.text = "알림이 없어요"
        $0.textColor = .f4
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
    }
    
    let noneContentLbl = UILabel().then {
        $0.text = "알림을 설정하고 알림을 받아 보세요"
        $0.textColor = .f4
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
    }
    
    let noneSettingLbl = UILabel().then {
        $0.text = "알림 설정하기"
        $0.textColor = .m1
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
    }
    
    //알림 있을 때 
    let RecordBgView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .m5
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addComponents()
        setConstraints()
        bind()
        changeUI(noticeState)
    }
    
    func addComponents() {
        [navigationView, RecordBgView, bellImg, nonetitleLbl, noneContentLbl, noneSettingLbl].forEach{
            view.addSubview($0)
        }
        
        RecordBgView.register(NoticeCell.self, forCellWithReuseIdentifier:NoticeCell.identifier)
        RecordBgView.delegate = self
        RecordBgView.dataSource = self
    }
    
    func setConstraints() {
        navigationView.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        bellImg.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom).offset(113)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        nonetitleLbl.snp.makeConstraints{
            $0.top.equalTo(bellImg.snp.bottom).offset(27)
            $0.centerX.equalToSuperview()
        }
        
        noneContentLbl.snp.makeConstraints{
            $0.top.equalTo(nonetitleLbl.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        noneSettingLbl.snp.makeConstraints{
            $0.top.equalTo(noneContentLbl.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        RecordBgView.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
    }
    
    func bind() {
        navigationView.backBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
        .disposed(by: disposeBag)
    }

    func changeUI(_ type: noticeState) {
        switch type {
        case .none:
            bellImg.isHidden = false
            nonetitleLbl.isHidden = false
            noneContentLbl.isHidden = false
            noneSettingLbl.isHidden = false
            RecordBgView.isHidden = true
            break
        case .notice:
            bellImg.isHidden = true
            nonetitleLbl.isHidden = true
            noneContentLbl.isHidden = true
            noneSettingLbl.isHidden = true
            RecordBgView.isHidden = false
            break
        }
    }
}


extension NoticeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoticeCell.identifier, for: indexPath) as? NoticeCell else { fatalError() }
        cell.backgroundColor = UIColor(hex: "F7FFF2")
        cell.layer.cornerRadius = 10
        return cell
    }
}

extension NoticeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width - Const.padding * 2
        return CGSize(
            width: width,
            height: width * 0.3
        )
    }
}
