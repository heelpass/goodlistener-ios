//
//  ProfileImageSelectCell.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/18.
//

import Foundation
import UIKit
import SnapKit
import Then

class ProfileImageSelectCell: UICollectionViewCell, SnapKitType {
    
    static let identifier = "ProfileImageSelectCell"
    
    let profileImage = UIImageView().then {
        $0.image = UIImage(named: "main_img_step_01")
        $0.layer.cornerRadius = (UIScreen.main.bounds.width - (Const.padding*4) - 26) / 6
        $0.layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addComponents() {
        contentView.addSubview(profileImage)
    }
    
    func setConstraints() {
        profileImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
