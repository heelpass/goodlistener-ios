//
//  SwipeButton.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/22.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SwipeButton: UIButton, SnapKitType {
    
    let disposeBag = DisposeBag()
    private let successCnt: CGFloat = 176
    
    // 스와이프 성공여부
    var swipeSuccessResult = PublishRelay<Void>()
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        $0.layer.cornerRadius = 64 / 2
    }
    
    private let swipeView = UIView().then {
        $0.backgroundColor = UIColor(r: 233, g: 110, b: 105)
        $0.layer.cornerRadius = 56 / 2
    }
    
    private let callIco = UIImageView().then {
        $0.image = UIImage(named: "ico_call_stop")
    }

    private let textLabel = UILabel().then {
        $0.text = "밀어서 종료하기"
        $0.font = FontManager.shared.notoSansKR(.regular, 18)
        $0.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addComponents()
        setConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
    func addComponents() {
        [backgroundView, textLabel, swipeView, callIco].forEach { self.addSubview($0) }
        swipeView.addSubview(callIco)
    }
    
    func setConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        swipeView.snp.makeConstraints {
            $0.size.equalTo(56)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(backgroundView).inset(4)
        }
        
        callIco.snp.makeConstraints {
            $0.width.equalTo(34)
            $0.height.equalTo(12)
            $0.center.equalToSuperview()
        }
        
        textLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(40)
            $0.centerY.equalToSuperview()
        }
    }
    
    func bind() {
        swipeView.rx.panGesture()
            .when(.began, .changed, .ended)
            .subscribe(onNext: { [weak self] pan in
                guard let self = self else { return }
                let translation = pan.translation(in: self.swipeView)
                let velocity = pan.velocity(in: self.swipeView)
                
                var transX: CGFloat = 0
                
                // 왼쪽으로 스와이프 불가능
                if translation.x <= 0 {
                    self.textLabel.isHidden = false
                    transX = max(translation.x, 0)
                } else {
                    transX = min(self.successCnt,translation.x)
                }
                
                Log.d(transX)
                
                switch pan.state {
                case .began:
                    break
                case .changed:
                    self.backgroundView.snp.updateConstraints {
                        $0.left.equalToSuperview().inset(transX)
                    }
                    self.textLabel.isHidden = transX > 0
                    
                case .ended:
                    
                    // 종료 성공
                    if transX == self.successCnt {
                        self.swipeSuccessResult.accept(())
                        return
                    }
                    // 빠른속도로 스와이프 한 경우 종료됨
                    else if velocity.x > 1000 {
                        self.textLabel.isHidden = true
                        UIView.animate(withDuration: 0.3, animations: {
                            self.backgroundView.snp.updateConstraints {
                                $0.left.equalToSuperview().inset(self.successCnt)
                            }
                            self.layoutIfNeeded()
                        }, completion: { _ in
                            self.swipeSuccessResult.accept(())
                            return
                        })
                    }
                    // 종료 실패
                    else {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.backgroundView.snp.updateConstraints {
                                $0.left.equalToSuperview()
                            }
                            self.layoutIfNeeded()
                        }, completion: { _ in
                            self.textLabel.isHidden = false
                        })
                    }
                    
                default:
                    self.textLabel.isHidden = true
                }
                
            })
            .disposed(by: disposeBag)
    }
}
