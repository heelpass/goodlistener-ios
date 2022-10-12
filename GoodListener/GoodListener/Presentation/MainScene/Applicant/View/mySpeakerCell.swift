//
//  mySpeakerCell.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/10/11.
//

import UIKit
import RxCocoa

class mySpeakerCell: UICollectionViewCell, SnapKitType {
    static let identifier = "mySpeakerCell"
    var emojiData: BehaviorRelay<[String]> = .init(value: ["check","check","none","check","none","check"])
    
    let containerView = UIView().then{
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor(hex: "#B1B3B5").cgColor
        $0.layer.applySketchShadow(color: UIColor(hex: "#B1B3B5"), alpha: 0.7, x: 0, y: 0, blur: 15, spread: 0)
    }
    
    let daycheckLbl = UILabel().then{
        let dayformat = "%d회/7일 진행 중"
        $0.text = String(format: dayformat, 3) //api data
        $0.font = FontManager.shared.notoSansKR(.bold, 14)
        $0.textColor = .m1
        $0.textAlignment = .center
    }
    
    let profileImg = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "person")
        $0.contentMode = .scaleAspectFill
    }
    
    let introLbl = UILabel().then {
        $0.textAlignment = .left
        $0.numberOfLines = 2
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
        $0.textColor = .f4
        $0.lineBreakMode = .byTruncatingTail
        $0.text = "안녕하세요?\n저는 행복해지고 싶은 지은이에요"
    }
    
    let scheduleLbl = UILabel().then{
        $0.text = "대화 시간"
        $0.font = FontManager.shared.notoSansKR(.bold, 14)
    }
        
    let timeLbl = UILabel().then {
        $0.text = "매일 오후 10:20"
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f7
    }
    
    let dateLbl = UILabel().then {
        $0.text = "2022.8.2 ~ 8.8 (7일간)"
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f7
    }
    
    let recordLbl = UILabel().then {
        $0.text = "대화 기록"
        $0.font = FontManager.shared.notoSansKR(.bold, 14)
    }
    
    lazy var sevendaysRecord = RecordCollectionView(frame: .zero, emojiData: emojiData.value)
    
    override init(frame: CGRect){
        super.init(frame: frame)
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    
    func addComponents() {
        contentView.addSubview(containerView)
        
        [daycheckLbl, profileImg, introLbl, scheduleLbl, timeLbl, dateLbl, recordLbl, sevendaysRecord].forEach{
            containerView.addSubview($0)
        }
    }
    
    func setConstraints() {
        containerView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        daycheckLbl.snp.makeConstraints{
            $0.top.equalToSuperview().offset(40)
            $0.left.equalToSuperview().offset(30)
        }
        
        introLbl.snp.makeConstraints {
            $0.top.equalTo(daycheckLbl.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(30)
        }
        
        profileImg.snp.makeConstraints{
            $0.top.equalTo(introLbl.snp.bottom).offset(25)
            $0.left.equalToSuperview().offset(30)
            $0.size.equalTo(100)
        }
        
        scheduleLbl.snp.makeConstraints{
            $0.top.equalTo(profileImg.snp.bottom).offset(13)
            $0.left.equalToSuperview().offset(30)
        }
        
        timeLbl.snp.makeConstraints{
            $0.top.equalTo(scheduleLbl.snp.bottom).offset(6)
            $0.left.equalToSuperview().offset(30)
        }
        
        dateLbl.snp.makeConstraints{
            $0.top.equalTo(timeLbl.snp.bottom)
            $0.left.equalToSuperview().offset(30)
        }
        
        recordLbl.snp.makeConstraints{
            $0.top.equalTo(dateLbl.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(30)
        }
        
        sevendaysRecord.snp.makeConstraints{
            $0.top.equalTo(recordLbl.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-26)
        }
    }

}
