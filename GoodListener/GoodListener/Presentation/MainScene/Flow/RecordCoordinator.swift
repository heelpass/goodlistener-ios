//
//  RecordCoordinator.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/07/26.
//

import Foundation
import UIKit

protocol RecordCoordinating: AnyObject {
    
}

class RecordCoordinator: CoordinatorType {
    var childCoordinators: [CoordinatorType] = []
    weak var parentCoordinator: MainCoordinating?
    
    var navigationController: UINavigationController
    
    init(coordinating: MainCoordinating?) {
        self.navigationController = UINavigationController()
        self.navigationController.isNavigationBarHidden = true
        self.parentCoordinator = coordinating
    }
    
    func start() {
        let vc = RecordViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension RecordCoordinator: RecordCoordinating {
    
}
