//
//  EmojiTagCell.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/08/22.
//


import UIKit

enum EmojiState{
    case selected
    case unselected
}

class EmojiTagCell: UICollectionViewCell{

    static let identifier = "EmojiTagCell"

    let emojiImgView = UIImageView().then{
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let emojiLbl: BasePaddingLabel = {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 6, left: 13, bottom: 6, right: 13))
        label.textAlignment = .center
        label.backgroundColor = UIColor(hex: "#F4F4F4")
        label.text = "감정"
        label.textColor = .f3
        label.font = FontManager.shared.notoSansKR(.regular, 14)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 15
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [emojiImgView, emojiLbl].forEach{
            addSubview($0)
        }

        emojiImgView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(38)
        }
        
        emojiLbl.snp.makeConstraints {
            $0.top.equalTo(emojiImgView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()

        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configUI(_ type: EmojiState) {
        switch type {
        case .selected:
            emojiLbl.backgroundColor = UIColor(hex: "#979797")
        case .unselected:
            emojiLbl.backgroundColor = UIColor(hex: "#F4F4F4")
        }
    }
}
