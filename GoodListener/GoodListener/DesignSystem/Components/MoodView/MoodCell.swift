//
//  TagCell.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/11.
//

import UIKit
import Then
import SnapKit

enum CellState {
    case selected
    case deselected
}

enum MoodType: String {
    case friendly = "다정한"
    case warm = "따뜻한"
    case dependable = "믿음직한"
    case joyful = "즐거운"
    case empathize = "공감해주는"
}

class MoodCell: UICollectionViewCell {
    
    static let identifier = "MoodCell"
    
    let label = UILabel().then {
        $0.text = "TAG"
        $0.font = FontManager.shared.notoSansKR(.bold, 14)
        $0.textColor = .f3
    }
    
    let background = UIView().then {
        $0.backgroundColor = .m3
        $0.layer.cornerRadius = 19
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(background)
        contentView.addSubview(label)
        
        background.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configUI(_ type: CellState) {
        switch type {
        case .selected:
            label.textColor = .m5
            background.backgroundColor = .m1
        case .deselected:
            label.textColor = .f3
            background.backgroundColor = .m3
        }
    }
}

