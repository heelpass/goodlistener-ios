//
//  RecordBgCell.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/08/29.
//

import UIKit

class RecordBgCell: UICollectionViewCell, SnapKitType{
    
    static let identifier = "RecordBgCell"
    
//    let recordStack = UIStackView().then {
//        $0.axis = .vertical
//        $0.backgroundColor = .clear
//    }
//
//    let dayrecord = RecordCollectionView(frame: .zero, dayData: RecordDataList.dayTextList)
    
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
//        contentView.addSubview(recordStack)
//        [dayrecord].forEach{
//            recordStack.addArrangedSubview($0)
//        }
        contentView.addSubview(dayrecord)
    }
    
    func setConstraints() {
//        recordStack.snp.makeConstraints{
//            $0.top.equalToSuperview().offset(160)
//            $0.left.equalToSuperview().offset(15)
//            $0.right.equalToSuperview().offset(-15)
//            $0.bottom.equalToSuperview().offset(-20)
//        }
        dayrecord.snp.makeConstraints{
            $0.top.left.right.bottom.equalToSuperview()
        }

    }
}
