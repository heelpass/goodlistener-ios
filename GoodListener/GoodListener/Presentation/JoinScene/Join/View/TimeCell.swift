//
//  TimeCell.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/08/24.
//

import UIKit


enum TimeState {
    case selected
    case unselected
}

class TimeCell: UICollectionViewCell {
    
    static let identifier = "TimeCell"
    
    let background = UIView().then {
        $0.backgroundColor = .m5
        $0.layer.cornerRadius = 5
    }
    
    let timeLbl = UILabel().then {
        $0.text = "오후 9:00"
        $0.textAlignment = .center
        $0.textColor = .f3
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(background)
        contentView.addSubview(timeLbl)
       
        background.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        timeLbl.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configUI(_ type: TimeState) {
        switch type {
        case .selected:
            timeLbl.textColor = .m1
            background.layer.borderWidth = 2
            background.layer.borderColor = UIColor.m1.cgColor
        case .unselected:
            timeLbl.textColor = .f3
            background.layer.borderWidth = 2
            background.layer.borderColor = UIColor.f6.cgColor
        }
    }
}
