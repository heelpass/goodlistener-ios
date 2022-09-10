//
//  RecordViewController.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/07/26.
//

import UIKit
import RxSwift

enum recordState{
    case nothing
    case progress
}

class RecordVC: UIViewController, SnapKitType{
    weak var coordinator: RecordCoordinating?
    var recordState: recordState = .progress
    var disposeBag = DisposeBag()
    
    let navigationView = NavigationView(frame: .zero, type: .notice)
    
    let titleLbl = UILabel().then {
        $0.text = "나의 대화 기록"
        $0.textColor = .f2
        $0.font = FontManager.shared.notoSansKR(.bold, 18)
    }
    
    //진행 중인 대화가 없을 때(nothing)
    let nothingImg = UIImageView().then{
        $0.image = #imageLiteral(resourceName: "main_img_notalk")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let nothingLbl = UILabel().then {
        $0.text = "아직 진행 중인 대화가 없어요"
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.regular, 15)
    }

    //진행 중인 대화 있을 때(progress)
    let RecordBgView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .m6
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .m6
        addComponents()
        setConstraints()
        changeUI(recordState)
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cnt = DBManager.shared.unreadfilter()
        navigationView.remainNoticeView.isHidden = cnt == 0
        navigationView.remainNoticeLbl.text = "+\(cnt)"
    }
    
    func addComponents() {
        [navigationView, titleLbl, RecordBgView, nothingImg, nothingLbl].forEach{
            view.addSubview($0)
        }
        navigationView.backgroundColor = .m6

        RecordBgView.register(RecordBgCell.self, forCellWithReuseIdentifier:RecordBgCell.identifier)
        RecordBgView.delegate = self
        RecordBgView.dataSource = self
    }
    
    func setConstraints() {
        navigationView.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(35)
        }
        
        titleLbl.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom).offset(35)
            $0.left.equalToSuperview().offset(30)
        }
        
        nothingImg.snp.makeConstraints{
            $0.top.equalTo(titleLbl.snp.bottom).offset(115)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        nothingLbl.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nothingImg.snp.bottom).offset(32)
        }
        
        RecordBgView.snp.makeConstraints{
            $0.top.equalTo(titleLbl.snp.bottom).offset(23)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
    
    func bind() {
        navigationView.rightBtn.rx.tap
            .bind(onNext: {[weak self] in
                self?.coordinator?.moveToNotice()
            })
            .disposed(by: disposeBag)
    }
    
    func changeUI(_ type: recordState) {
        switch type{
        case .nothing:
            nothingImg.isHidden = false
            nothingLbl.isHidden = false
            RecordBgView.isHidden = true
            break
        case .progress:
            nothingImg.isHidden = true
            nothingLbl.isHidden = true
            RecordBgView.isHidden = false
            break
        }
    }
}

extension RecordVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordBgCell.identifier, for: indexPath) as? RecordBgCell else { fatalError() }
        cell.backgroundColor = UIColor.m5.withAlphaComponent(0.8)
        cell.layer.cornerRadius = 20
        return cell
    }
}

extension RecordVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Log.d("\(indexPath.section)and \(indexPath.row)")
    }
}

extension RecordVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width - Const.padding * 2
        return CGSize(
            width: width,
            height: width * 0.8
        )
    }
}
