//
//  UIView+Extension.swift
//  GoodListener
//
//  Created by cheonsong on 2022/07/26.
//

import Foundation
import RxSwift
import RxCocoa
import RxGesture

extension UIView {
    /**
        UIView tapGesture프로퍼티 추가, 기본적으로 1초 쓰로틀이 걸려있습니다.
     */
    var tapGesture: Observable<UITapGestureRecognizer> {
        get {
            return self.tapGesture(1)
        }
    }
    
    public func tapGesture(_ throttle: Int = 1, _ state: UIGestureRecognizer.State = .recognized, useThrottle: Bool = true ) -> Observable<UITapGestureRecognizer> {
        return useThrottle ?
        self.rx.tapGesture().when(state).throttle(.seconds(throttle), latest: false, scheduler: MainScheduler.instance) :
        self.rx.tapGesture().when(state)
        
    }
}
