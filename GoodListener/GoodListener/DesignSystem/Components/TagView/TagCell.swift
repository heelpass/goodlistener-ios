//
//  TagCell.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/11.
//

import UIKit
import Then
import SnapKit

enum TagState {
    case selected
    case deselected
}

class TagCell: UICollectionViewCell {
    
    static let identifier = "TagCell"
    
    var state: TagState = .deselected
    
    let label = UILabel().then {
        $0.text = "TAG"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
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
    
    func configUI(_ type: TagState) {
        self.state = type
        switch type {
        case .selected:
            label.textColor = .f3
            background.backgroundColor = UIColor(red: 247/255, green: 255/255, blue: 242/255, alpha: 1)
            background.layer.borderWidth = 2
            background.layer.borderColor = UIColor.m1.cgColor
        case .deselected:
            label.textColor = .f4
            background.backgroundColor = .m3
            background.layer.borderWidth = 0
        }
    }
}

