//
//  HomeCoordinator.swift
//  GoodListener
//
//  Created by cheonsong on 2022/07/26.
//

import Foundation
import UIKit

protocol HomeCoordinating: AnyObject {
    func call()
    func join()
    func moveToNotice()
}

class HomeCoordinator: CoordinatorType {
    var childCoordinators: [CoordinatorType] = []
    weak var parentCoordinator: MainCoordinating?
    
    var navigationController: UINavigationController
    
    init(coordinating: MainCoordinating?) {
        self.navigationController = UINavigationController()
        self.navigationController.isNavigationBarHidden = true
        self.parentCoordinator = coordinating
    }
    
    func start() {
        let vc = HomeVC()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension HomeCoordinator: HomeCoordinating {
    func call() {
        parentCoordinator?.call(model: nil)
    }
    
    func join() {
        parentCoordinator?.join()
    }
    
    func moveToNotice() {
        let vc = NoticeVC()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
