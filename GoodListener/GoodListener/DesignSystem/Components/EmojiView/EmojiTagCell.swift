//
//  EmojiTagCell.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/08/22.
//


import UIKit



class EmojiTagCell: UICollectionViewCell{

    static let identifier = "EmojiTagCell"

    let emojiImgView = UIImageView().then{
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let emojiLbl = UILabel().then {
        $0.text = "감정"
        $0.textColor = .f3
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
    }
    
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
    
}
