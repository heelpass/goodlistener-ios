//
//  TimeView.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/08/24.
//

import UIKit
import RxCocoa
import RxSwift

struct TimeList { //dictionary
    static let timeList = ["오후 9:00", "오후 9:20", "오후 9:40", "오후 10:00", "오후 10:20", "오후 10:40", "오후 11:00", "오후 11:20", "오후 11:40"]
    static let convertedTime = ["21:00:00", "21:20:00", "21:40:00", "22:00:00", "22:20:00", "22:40:00", "23:00:00", "23:20:00", "23:40:00"]
}

class TimeView: UIView {

    var timeData: [String] = []
    var convertedtimeData: [String] = []
    var selectedTime: BehaviorRelay<[String]> = .init(value: [""])

    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .clear
        view.register(TimeCell.self, forCellWithReuseIdentifier: TimeCell.identifier)
        view.delegate = self
        view.dataSource = self
        view.allowsMultipleSelection = true
        
        return view
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(frame: CGRect, timeList: [String], convertedTime: [String]) {
        self.init(frame: frame)
        self.timeData = timeList
        self.convertedtimeData = convertedTime
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
}


extension TimeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        timeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeCell.identifier, for: indexPath) as? TimeCell else {fatalError()}
        cell.background.layer.borderWidth = 2
        cell.background.layer.borderColor = UIColor.f6.cgColor
        cell.timeLbl.text = timeData[indexPath.row]
        return cell
    }
}


extension TimeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TimeCell else { return }

        if(selectedTime.value.count <= 2){
            cell.configUI(.selected)
            
            if self.selectedTime.value == [""] {
                self.selectedTime.accept([JoinVC.apiformateDate + convertedtimeData[indexPath.row]])
            } else {
                self.selectedTime.accept(selectedTime.value + [JoinVC.apiformateDate + convertedtimeData[indexPath.row]])
            }
        }
         //Log.i(selectedTime.value)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TimeCell else { return }
        cell.configUI(.unselected)
        var selectedTimeList: [String] = selectedTime.value

        if self.selectedTime.value != [""] {
            for (index, value) in selectedTime.value.enumerated() {
                if value == JoinVC.apiformateDate + convertedtimeData[indexPath.row]
                    {
                    selectedTimeList.remove(at: index)
                    selectedTime.accept(selectedTimeList)
                }
            }
        }
        //Log.i(selectedTime.value)
    }
}

extension TimeView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (frame.size.width/3)-8,
            height: ((frame.size.width/3)-20)/2
        )
    }
    
}
