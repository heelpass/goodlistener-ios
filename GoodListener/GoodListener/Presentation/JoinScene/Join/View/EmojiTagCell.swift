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
    
    let containerView = UIView().then {
        $0.backgroundColor = .m3
        $0.layer.cornerRadius = 20
    }

    let emojiImgView = UIImageView().then{
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let emojiLbl = UILabel().then {
        $0.text = "감정"
        $0.textColor = .f3
        //$0.backgroundColor = .systemYellow
        $0.font = FontManager.shared.notoSansKR(.bold, 14)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(containerView)
        [emojiImgView, emojiLbl].forEach{
            containerView.addSubview($0)
        }
        
        containerView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        emojiImgView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(8)
            $0.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        emojiLbl.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(emojiImgView.snp.right).offset(5)
        }
   
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureUI(_ type: EmojiTagState){
        switch type {
        case .selected:
            containerView.backgroundColor = .m1
            emojiLbl.textColor = .m5
        case .unselected:
            containerView.backgroundColor = .m3
            emojiLbl.textColor = .f2
        }
    }
}
