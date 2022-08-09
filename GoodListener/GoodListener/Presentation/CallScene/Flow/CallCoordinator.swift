//
//  CallCoordinator.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/09.
//

import Foundation
import UIKit

protocol CallCoordinating {
    func moveToReview() // 통화가 끝난 후 후기 페이지로 이동
    func moveToMain()   // 후기 작성 후 메인으로 이동
}

class CallCoordinator: CoordinatorType {
    var childCoordinators: [CoordinatorType] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isToolbarHidden = true
    }
    
    func start() {
        let callVC = CallVC()
        callVC.coordinator = self
        navigationController.pushViewController(callVC, animated: false)
    }
}

extension CallCoordinator: CallCoordinating {
    func moveToReview() {
        
    }
    
    func moveToMain() {
        navigationController.dismiss(animated: true)
    }
    
    
}
