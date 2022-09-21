//
//  EmojiTagCell.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/08/22.
//

import UIKit

enum EmojiTagState {
    case selected
    case unselected
}

class EmojiTagCell: UICollectionViewCell{

    static let identifier = "EmojiTagCell"

    let emojiImgView = UIImageView().then{
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(emojiImgView)

        emojiImgView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(8)
            $0.size.equalTo(CGSize(width: 38, height: 38))
        }
   
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
