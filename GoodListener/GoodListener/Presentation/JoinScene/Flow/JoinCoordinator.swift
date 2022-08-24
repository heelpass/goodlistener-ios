//
//  JoinCoordinator.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/08/24.
//

import Foundation
import UIKit

protocol JoinCoordinating: AnyObject {
    func moveToJoinMatch()
    func moveToHome()
}

class JoinCoordinator: CoordinatorType {
    var childCoordinators: [CoordinatorType] = []
    
    weak var parentCoordinator: CoordinatorType?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
    }
    
    func start() {
        let joinVC = JoinVC()
        joinVC.coordinator = self
        navigationController.pushViewController(joinVC, animated: false)
    }
}


extension JoinCoordinator: JoinCoordinating {
    func moveToJoinMatch() {
        let vc = JoinMatchVC()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func moveToHome() {
        parentCoordinator?.childDidFinish(self)
        navigationController.dismiss(animated: true)
    }
    
}
