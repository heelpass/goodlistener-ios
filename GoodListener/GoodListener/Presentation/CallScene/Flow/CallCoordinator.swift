//
//  CallCoordinator.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/09.
//

import Foundation
import UIKit

protocol CallCoordinating: AnyObject {
    func moveToReview() // 통화가 끝난 후 후기 페이지로 이동
    func moveToMain()   // 후기 작성 후 메인으로 이동
}

class CallCoordinator: CoordinatorType {
    func start() {
        
    }
    
    var childCoordinators: [CoordinatorType] = []
    
    var navigationController: UINavigationController
    var parentCoordinator: CoordinatorType?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
    }
    
    func start(model: [MatchedSpeaker]? = nil) {
        let callVC = CallVC()
        callVC.model = model
        callVC.coordinator = self
        navigationController.pushViewController(callVC, animated: false)
    }
}

extension CallCoordinator: CallCoordinating {
    func moveToReview() {
        let vc = CallReviewVC()
        vc.coordinator = self
        vc.type = .day
        navigationController.pushViewController(vc, animated: true)
    }
    
    func moveToMain() {
        parentCoordinator?.childDidFinish(self)
        navigationController.dismiss(animated: true)
        // 부모 코디네이터로부터 자식(self)코디네이터를 제거해야함
        // 그렇지 않으면 메모리 누수 발생
    }
    
    
}
