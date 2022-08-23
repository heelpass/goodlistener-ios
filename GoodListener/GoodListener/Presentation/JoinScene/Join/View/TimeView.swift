//
//  TimeView.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/08/23.
//

import UIKit
import RxCocoa
import RxSwift

struct TimeList {
    static let timeList = ["오후 9:00", "오후 9:20", "오후 9:40", "오후 10:00", "오후 10:20", "오후 10:40", "오후 11:00", "오후 11:20", "오후 11:40"]
}

class TimeView: UIView {

    var timeData: [String] = []
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .clear
        view.register(TimeCell.self, forCellWithReuseIdentifier: TimeCell.identifier)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(frame: CGRect, timeList: [String]) {
        self.init(frame: frame)
        self.timeData = timeList
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
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 2
        cell.layer.borderColor = CGColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
        cell.timeLbl.text = timeData[indexPath.row]
        return cell
    }
}


extension TimeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected section\(indexPath.section) and row \(indexPath.row)")
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
