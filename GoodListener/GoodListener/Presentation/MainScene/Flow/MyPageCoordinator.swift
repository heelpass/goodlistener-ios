//
//  MyPageCoordinator.swift
//  GoodListener
//
//  Created by cheonsong on 2022/07/26.
//

import Foundation
import UIKit

protocol MyPageCoordinating: AnyObject {
    func logout()
}

class MyPageCoordinator: CoordinatorType {
    var childCoordinators: [CoordinatorType] = []
    weak var parentCoordinator: MainCoordinating?
    
    var navigationController: UINavigationController
    
    init(coordinating: MainCoordinating?) {
        self.navigationController = UINavigationController()
        self.navigationController.isNavigationBarHidden = true
        self.parentCoordinator = coordinating
    }
    
    func start() {
        let vc = MyPageViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension MyPageCoordinator: MyPageCoordinating {
    func logout() {
        parentCoordinator?.logout()
    }
}
