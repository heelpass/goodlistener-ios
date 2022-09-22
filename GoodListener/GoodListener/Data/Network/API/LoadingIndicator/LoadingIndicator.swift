//
//  LoadingIndicator.swift
//  GoodListener
//
//  Created by cheonsong on 2022/09/20.
//

import Foundation
import NVActivityIndicatorView

struct LoadingIndicator {
    static let indicator = NVActivityIndicatorView(frame: UIScreen.main.bounds, type: .circleStrokeSpin, color: .m1, padding: UIScreen.main.bounds.width)
    
    static func start() {
        UIApplication.getMostTopViewController()!.view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    static func stop() {
        indicator.stopAnimating()
        indicator.removeFromSuperview()
    }
}
