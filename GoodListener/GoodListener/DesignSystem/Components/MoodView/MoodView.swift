//
//  TagCollectionView.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/11.
//

import UIKit
import RxCocoa
import RxSwift

class MoodView: UIView {
    
    var tagData: [String] = ["다정한", "따뜻한", "믿음직한", "즐거운", "공감해주는"]
    
    var selectedTag: BehaviorRelay<String> = .init(value: "")
    
    lazy var collectionView: UICollectionView = {
        
        let layout = TagCollectionViewLayout()
        layout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.register(MoodCell.self, forCellWithReuseIdentifier: MoodCell.identifier)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func calculateCellWidth(index: Int) -> CGFloat {
        let label = UILabel()
        label.text = tagData[index]
        label.font = FontManager.shared.notoSansKR(.bold, 14)
        label.sizeToFit()
        // ✅ 32(여백)
        return label.frame.width + 24
    }
    
    func moodCollectionViewWidth()-> CGFloat {
        let spacing: CGFloat = 10
        var width: CGFloat = spacing * 2
        
        for i in 0...2 {
            let label = UILabel()
            label.text = tagData[i]
            label.font = FontManager.shared.notoSansKR(.bold, 14)
            label.sizeToFit()
            
            width += (label.frame.width + 24)
        }
        Log.d(width)
        return width
    }
    
    func moodCollectionViewHeight()-> CGFloat {
        let spacing: CGFloat = 10
        var totalCellWidth: CGFloat = Const.padding * 2
        let cellSpacing: CGFloat = 24
        let screenWidth = UIScreen.main.bounds.width
        var height: CGFloat = 113
        
        tagData.forEach { (text) in
            let label = UILabel()
            label.text = text
            label.font = FontManager.shared.notoSansKR(.bold, 14)
            label.sizeToFit()
            totalCellWidth += (label.frame.width + cellSpacing)
            if totalCellWidth + spacing < screenWidth {
                totalCellWidth += spacing
            } else {
                height += (38 + spacing)
                totalCellWidth = Const.padding * 2
            }
        }

        return height
    }

}

extension MoodView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoodCell.identifier, for: indexPath) as! MoodCell
        
        cell.label.text = tagData[indexPath.row]
        tagData[indexPath.row] == selectedTag.value ? cell.configUI(.selected) : cell.configUI(.deselected)
        
        return cell
    }
    
}

extension MoodView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.visibleCells.forEach {
            if let cell = $0 as? MoodCell {
                cell.configUI(.deselected)
            }
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? MoodCell else { return }
        cell.configUI(.selected)
        self.selectedTag.accept(tagData[indexPath.row])
        
    }
}

extension MoodView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = calculateCellWidth(index: indexPath.row)
        
        return CGSize(width: cellWidth, height: 38)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
