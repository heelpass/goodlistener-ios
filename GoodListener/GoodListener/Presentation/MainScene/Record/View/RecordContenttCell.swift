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
        $0.font = FontManager.shared.notoSansKR(.regular, 10)
    }
    
    let emojiImg = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "check")
        $0.contentMode = .scaleAspectFill
    }
    
    let scoreLbl = UILabel().then{
        $0.text = "8.2"
        $0.textColor = .f3
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.bold, 12)
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
        [dayLbl, emojiImg, scoreLbl].forEach{
            contentView.addSubview($0)
        }
    }
    
    func setConstraints() {
        dayLbl.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
        }
        emojiImg.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.size.equalTo(24)
        }
        scoreLbl.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    func changeUI(_ type: ContentState) {
        switch type{
        case .day:
            dayLbl.isHidden = false
            emojiImg.isHidden = true
            scoreLbl.isHidden = true
            break
        case .emoji:
            dayLbl.isHidden = true
            emojiImg.isHidden = false
            scoreLbl.isHidden = true
            break
        case .score:
            dayLbl.isHidden = true
            emojiImg.isHidden = true
            scoreLbl.isHidden = false
            break
        }
    }
}
