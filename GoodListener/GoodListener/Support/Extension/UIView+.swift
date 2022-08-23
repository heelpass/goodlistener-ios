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
    
    /// roundCorners
    /// - Parameters:
    ///   - corners: 라운드 코너 [.topLeft, .topRight]
    ///   - radius: 8.0
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    
    // Keyboard를 올릴때 원하는 뷰를 남은 여백의 가운대로 이동시키기 위해 이동값을 계산하는 함수
    func calculateTranslationY(_ keyboardHeight: CGFloat)-> CGFloat {
        let remain = UIScreen.main.bounds.height - keyboardHeight
        return frame.midY - (remain/2)
    }
}
