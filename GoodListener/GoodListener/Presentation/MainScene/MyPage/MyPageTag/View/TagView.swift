//
//  TagCollectionView.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/11.
//

import UIKit

class TagView: UIView {
    
    var tagData: [String] = []
    
    var selectedTag: String = "10대"
    
    var title = UILabel().then {
        $0.text = "나이"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f6
    }
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
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
    
    convenience init(frame: CGRect, data: [String]) {
        self.init(frame: frame)
        self.tagData = data
        
        addSubview(title)
        addSubview(collectionView)
        title.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.left.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(10)
            $0.edges.equalToSuperview()
        }
    }
    
    func calculateCellWidth(index: Int) -> CGFloat {
        let label = UILabel()
        label.text = tagData[index]
        label.font = FontManager.shared.notoSansKR(.bold, 14)
        label.sizeToFit()
        // ✅ 32(여백)
        return label.frame.width + 32
    }

}

extension TagView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as! TagCell
        
        cell.label.text = tagData[indexPath.row]
        selectedTag == tagData[indexPath.row] ? cell.configUI(.selected) : cell.configUI(.deselected)
        
        return cell
    }
    
}

extension TagView: UICollectionViewDelegate {
    
}

extension TagView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = calculateCellWidth(index: indexPath.row)
        
        return CGSize(width: cellWidth, height: 38)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
