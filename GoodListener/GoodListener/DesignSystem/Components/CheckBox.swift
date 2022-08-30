//
//  CheckBox.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/30.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CheckBox: UIView {
    
    let disposeBag = DisposeBag()
    
    var isSelected: Bool {
        get {
            return selected.value
        }
        
        set {
            selected.accept(newValue)
        }
    }
    
    var selected = BehaviorRelay<Bool>(value: false)
    
    private let check = UIImageView().then {
        $0.image = UIImage(named: "doit_img_check_box_off")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(check)
        check.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        selected
            .subscribe(onNext: { [weak self] isSelected in
                self?.check.image = isSelected ? UIImage(named: "circle_check_box_on") : UIImage(named: "circle_check_box_off")
            })
            .disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.isSelected = !isSelected
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
