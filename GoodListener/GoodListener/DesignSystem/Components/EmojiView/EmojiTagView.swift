//
//  EmojiTagView.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/08/22.
//

import UIKit
import RxCocoa
import RxSwift

struct EmojiTagList {
    static let emojiImgList = ["emoji1", "emoji2", "emoji3", "emoji4", "emoji5"]
    static let emojiTextList = ["1", "2", "3", "4", "5"] //API 로 보낼 데이터
}

class EmojiTagView: UIView {
    
    var emojiImgData: [String] = []
    var emojiTextData: [String] = []
    
    var selectedemojiImg: BehaviorRelay<String> = .init(value: "")
    var selectedemojiText: BehaviorRelay<String> = .init(value: "")
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .clear
        view.register(EmojiTagCell.self, forCellWithReuseIdentifier: EmojiTagCell.identifier)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(frame: CGRect, emojiImgdata: [String], emojiTextdata:[String] ) {
        self.init(frame: frame)
        self.emojiImgData = emojiImgdata
        self.emojiTextData = emojiTextdata
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
           
        }
    }
}

extension EmojiTagView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiImgData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiTagCell.identifier, for: indexPath) as? EmojiTagCell else {fatalError()}
        
        cell.emojiImgView.image = UIImage(named:emojiImgData[indexPath.row])
        return cell
        
        
    }
}

extension EmojiTagView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiTagCell else { return }
        self.selectedemojiText.accept(emojiTextData[indexPath.row])
    }
}

extension EmojiTagView: UICollectionViewDelegateFlowLayout {
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         
         let collectionViewWidth = collectionView.frame.width
         let totalCellWidth = 38 * 6
         let totalSpacingWidth = 20 * 5
         
         let widthInset = (collectionViewWidth - CGFloat(totalCellWidth + totalSpacingWidth)) / 2

         return UIEdgeInsets(top: 0, left: widthInset, bottom: 0, right: widthInset)
         
     }
}
