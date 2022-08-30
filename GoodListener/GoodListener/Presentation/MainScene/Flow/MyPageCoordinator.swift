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
    func moveToSetting()
    func moveToTagPage()
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
        let vc = MyPageVC()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension MyPageCoordinator: MyPageCoordinating {
    func logout() {
        parentCoordinator?.logout()
    }
    
    func moveToSetting() {
        let vc = MyPageSetVC()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func moveToTagPage() {
        let vc = MyPageModifyVC()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
