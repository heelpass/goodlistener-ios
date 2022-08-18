//
//  profileImageSelectView.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/18.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class ProfileImageSelectView: UIView, SnapKitType {
    
    var images = BehaviorRelay<[UIImage?]>(value: [UIImage(named: "main_img_step_01"),
                                                  UIImage(named: "main_img_step_01"),
                                                  UIImage(named: "main_img_step_01"),
                                                  UIImage(named: "main_img_step_01"),
                                                  UIImage(named: "main_img_step_01"),
                                                  UIImage(named: "main_img_step_01")])
    
    let cellSize = (UIScreen.main.bounds.width - (Const.padding * 4) - 26) / 3
    var disposeBag = DisposeBag()
    
    let backgroundView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    }
    
    let container = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
    }
    
    let titleLbl = UILabel().then {
        $0.text = "원하시는 프로필 이미지를\n선택해주세요"
        $0.font = FontManager.shared.notoSansKR(.bold, 18)
        $0.textColor = .f2
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let completeBtn = GLButton().then {
        $0.title = "확인"
        $0.configUI(.deactivate)
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 26
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(ProfileImageSelectCell.self, forCellWithReuseIdentifier: ProfileImageSelectCell.identifier)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        setConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addComponents() {
        [backgroundView, container].forEach { addSubview($0) }
        [titleLbl, collectionView, completeBtn].forEach { container.addSubview($0) }
    }
    
    func setConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        container.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(Const.padding)
        }
        
        titleLbl.snp.makeConstraints {
            $0.top.equalToSuperview().inset(36)
            $0.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLbl.snp.bottom).offset(49)
            $0.left.right.equalToSuperview().inset(Const.padding)
            $0.height.equalTo(cellSize * 2 + 26)
        }
        
        completeBtn.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(70)
            $0.left.right.equalToSuperview().inset(Const.padding)
            $0.bottom.equalToSuperview().inset(18)
            $0.height.equalTo(Const.glBtnHeight)
        }
    }
    
    func bind() {
        images.bind(to: collectionView.rx.items(
            cellIdentifier: ProfileImageSelectCell.identifier, cellType: ProfileImageSelectCell.self)) { [weak self] row, model, cell in
                guard let self = self else { return }
                cell.profileImage.image = model
            }
            .disposed(by: disposeBag)
    }
}
