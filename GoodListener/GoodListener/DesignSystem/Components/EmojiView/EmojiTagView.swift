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
    static let emojiTextList = ["화남", "슬픔", "무기력", "긍정", "즐거움"]
}

class EmojiTagView: UIView {
    
    var emojiImgData: [String] = []
    var emojiTextData: [String] = []
    
    var selectedemojiText: BehaviorRelay<Int> = .init(value: 0)
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
        cell.emojiLbl.text = emojiTextData[indexPath.row]
        return cell
        
        
    }
}

extension EmojiTagView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiTagCell else { return }
        cell.configUI(.selected)
        self.selectedemojiText.accept(indexPath.row + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiTagCell else { return }
        cell.configUI(.unselected)
    }
}

//TODO: 작은 화면에서 대응 시 높이 조절
extension EmojiTagView: UICollectionViewDelegateFlowLayout {
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         
         let collectionViewWidth = collectionView.frame.width
         let totalCellWidth = 38 * 6
         let totalSpacingWidth = 20 * 5
         
         let widthInset = (collectionViewWidth - CGFloat(totalCellWidth + totalSpacingWidth)) / 2

         return UIEdgeInsets(top: 0, left: widthInset, bottom: 0, right: widthInset)
         
     }
}
