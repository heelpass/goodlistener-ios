//
//  Networkable.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/31.
//

import Foundation
import Moya
import NVActivityIndicatorView

protocol Networkable {
    /// provider객체 생성 시 Moya에서 제공하는 TargetType을 명시해야 하므로 타입 필요
    associatedtype Target: TargetType
    /// DIP를 위해 protocol에 provider객체를 만드는 함수 정의
    static func makeProvider() -> MoyaProvider<Target>
}

extension Networkable {
    
    static func makeProvider() -> MoyaProvider<Target> {
        /// access token 세팅
        let authPlugin = AccessTokenPlugin { _ in
            return UserDefaultsManager.shared.accessToken!
        }

      /// plugin객체를 주입하여 provider 객체
        LoadingIndicator.start()
        return MoyaProvider<Target>(plugins: [authPlugin])
    }
    
    static func makePopup(action: (()->Void)?) {
        let popup = GLPopup()
        popup.title = "네트워크 연결"
        popup.contents = "네트워크에 접속할 수 없습니다.\n네트워크 연결상태를 확인해주세요."
        popup.cancelIsHidden = false
        popup.completeAction = action
        popup.completeBtnTitle = "재시도"
        
        if let vc = UIApplication.getMostTopViewController() {
            if let tab = vc.tabBarController {
                tab.view.addSubview(popup)
                popup.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
            } else if let navi = vc.navigationController {
                navi.view.addSubview(popup)
                popup.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
            }
        }
    }
}
