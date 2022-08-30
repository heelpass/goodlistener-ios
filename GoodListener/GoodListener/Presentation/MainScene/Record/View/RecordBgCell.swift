//
//  RecordBgCell.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/08/29.
//

import UIKit

class RecordBgCell: UICollectionViewCell, SnapKitType{
    
    static let identifier = "RecordBgCell"
    
    let profileImg = UIImageView().then{
        $0.image = #imageLiteral(resourceName: "person")
        $0.contentMode = .scaleAspectFill
    }

    let nickNameLbl = UILabel().then {
        $0.text = "명랑한 지윤이"
        $0.textColor = .f3
        $0.font = FontManager.shared.notoSansKR(.bold, 14)
        $0.textAlignment = .center
    }
    
    let timeLbl = UILabel().then {
        $0.text = "매일 오후 10:20"
        $0.textColor = .f3
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textAlignment = .center
    }
    
    let periodLbl = UILabel().then {
        $0.text = "2022.8.2 ~ 8.8(7일간)"
        $0.textColor = .f3
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textAlignment = .center
    }
    
    let recordLbl = UILabel().then {
        $0.text = "대화 기록"
        $0.textColor = .f3
        $0.font = FontManager.shared.notoSansKR(.bold, 14)
        $0.textAlignment = .center
    }
    
    let dayrecord = RecordCollectionView(frame: .zero, dayData: RecordDataList.dayTextList, emojiData: RecordDataList.dayemojiList, scoreData: RecordDataList.dayScoreList)
    
    override init(frame: CGRect){
        super.init(frame: frame)
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

    }
    
    func addComponents() {
        [profileImg, nickNameLbl, timeLbl, periodLbl, recordLbl, dayrecord].forEach{
            contentView.addSubview($0)
        }
    }
    
    func setConstraints() {
        profileImg.snp.makeConstraints{
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.size.equalTo(80)
        }
        
        nickNameLbl.snp.makeConstraints{
            $0.top.equalToSuperview().offset(20)
            $0.left.equalTo(profileImg.snp.right).offset(20)
        }
        
        timeLbl.snp.makeConstraints{
            $0.top.equalTo(nickNameLbl.snp.bottom).offset(12)
            $0.left.equalTo(profileImg.snp.right).offset(20)
        }
        
        periodLbl.snp.makeConstraints{
            $0.top.equalTo(timeLbl.snp.bottom)
            $0.left.equalTo(profileImg.snp.right).offset(20)
        }
        
        recordLbl.snp.makeConstraints{
            $0.top.equalTo(profileImg.snp.bottom).offset(29)
            $0.left.equalToSuperview().offset(20)
        }
        
        dayrecord.snp.makeConstraints{
            $0.top.equalTo(recordLbl.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview().offset(-15)
        }
    }
}
