//
//  TimeCell.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/08/23.
//

import UIKit

class TimeCell: UICollectionViewCell {
    
    static let identifier = "TimeCell"
    
    let timeLbl = UILabel().then {
        $0.text = "오후 9:00"
        $0.textAlignment = .center
        $0.textColor = .f3
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(timeLbl)
        timeLbl.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //configureUI
}
