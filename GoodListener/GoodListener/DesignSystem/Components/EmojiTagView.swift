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
    static let emojiTextList = ["다정한", "따뜻한", "믿음직한", "즐거운", "공감해주는"]
}

class EmojiTagView: UIView {
    
    var emojiImgData: [String] = []
    var emojiTextData: [String] = []
    
    var selectedemojiImg: BehaviorRelay<String> = .init(value: "")
    var selectedemojiText: BehaviorRelay<String> = .init(value: "")
    var collectionHeight: NSLayoutConstraint!
    
    lazy var collectionView: UICollectionView = {
        let layout = EmojiTagFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
    
    func calculateCellWidth(index: Int) -> CGFloat {
        let label = UILabel()
        label.text = emojiTextData[index]
        label.font = FontManager.shared.notoSansKR(.bold, 14)
        label.sizeToFit()
        return label.frame.width + 52
    }
    
    func calculateCollectionViewHeight() -> CGFloat {
        let height = self.collectionView.contentSize.height
        return height
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
        
        collectionView.visibleCells.forEach {
            if let cell = $0 as? EmojiTagCell {
                cell.configureUI(.unselected)
            }
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiTagCell else { return }
        cell.configureUI(.selected)
        self.selectedemojiText.accept(emojiTextData[indexPath.row])
    }
}


extension EmojiTagView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = calculateCellWidth(index: indexPath.row)
        return CGSize(
            width: cellWidth,
            height: 38
        )
    }
}
