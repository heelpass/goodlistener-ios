//
//  RecordTextCell.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/08/29.
//

import UIKit

enum ContentState{
    case day
    case emoji
    case score
}

class RecordContentCell: UICollectionViewCell, SnapKitType {
    static let identifier = "RecordContentCell"
    
    //현재 cell 상태
    var contentState: ContentState = .day
    
    let dayLbl = UILabel().then{
        $0.text = "1일차"
        $0.textAlignment = .center
        $0.textColor = .f3
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
    }
    
    let emojiImg = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "emoji4")
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)

        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

    }
    
    func addComponents() {
        contentView.addSubview(dayLbl)
        contentView.addSubview(emojiImg)
    }
    
    func setConstraints() {
        dayLbl.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        emojiImg.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    func changeUI(_ type: ContentState) {
        switch type{
        case .day:
            dayLbl.isHidden = false
            emojiImg.isHidden = true
            break
        case .emoji:
            dayLbl.isHidden = true
            emojiImg.isHidden = false
            break
        case .score:
            dayLbl.isHidden = false
            emojiImg.isHidden = true
            break
        }
    }
}
