//
//  NoticeCell.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/09/03.
//

import UIKit

class NoticeCell: UICollectionViewCell {
    static let identifier = "Noticecell"
    
    let markImg = UIImageView().then{
        $0.image = #imageLiteral(resourceName: "ico_exclamation_green")
        $0.contentMode = .scaleAspectFill
    }
    
    let bgView = UIView().then {
        $0.backgroundColor = UIColor(hex: "F7FFF2")
        $0.layer.cornerRadius = 10
    }

    let guideLbl = UILabel().then {
        $0.text = "굿리스너 통화 안내"
        $0.textColor = .f4
        $0.font = FontManager.shared.notoSansKR(.regular, 12)
    }
    
    let noticeLbl = UILabel().then {
        $0.text = "5분 뒤에 전화가 올 예정입니다. 놓치지 말고 꼭 받아주세요🤗"
        $0.numberOfLines = 2
        $0.textColor = .f3
        $0.font = FontManager.shared.notoSansKR(.bold, 12)
    }
    
    let dayLbl = UILabel().then {
        $0.text = "2022.10.12"
        $0.textAlignment = .right
        $0.textColor = .f5
        $0.font = FontManager.shared.notoSansKR(.regular, 12)
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
        [markImg, bgView, dayLbl].forEach{
            contentView.addSubview($0)
        }
        [guideLbl, noticeLbl].forEach{
            bgView.addSubview($0)
        }
    }
    
    func setConstraints() {
        markImg.snp.makeConstraints{
            $0.top.left.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        bgView.snp.makeConstraints{
            $0.left.equalTo(markImg.snp.right).offset(5)
            $0.top.equalToSuperview()
            $0.width.equalToSuperview().offset(-20)
            $0.height.equalToSuperview().offset(-20)
        }
        
        guideLbl.snp.makeConstraints{
            $0.top.equalToSuperview().offset(16)
            $0.left.equalToSuperview().offset(16)
        }
        
        noticeLbl.sizeToFit()
        
        noticeLbl.snp.makeConstraints{
            $0.top.equalTo(guideLbl.snp.bottom).offset(5)
            $0.left.equalToSuperview().offset(16)
        }
        
        
        dayLbl.snp.makeConstraints{
            $0.top.equalTo(bgView.snp.bottom)
            $0.right.equalToSuperview()
        }
    }
}
