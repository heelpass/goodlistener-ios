//
//  ApplicantCoordinator.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/07/26.
//

import Foundation
import UIKit

protocol ApplicantCoordinating: AnyObject {
    func call(model: [MatchedSpeaker]?)
}

class ApplicantCoordinator: CoordinatorType {
    var childCoordinators: [CoordinatorType] = []
    weak var parentCoordinator: MainCoordinating?
    
    var navigationController: UINavigationController
    
    init(coordinating: MainCoordinating?) {
        self.navigationController = UINavigationController()
        self.navigationController.isNavigationBarHidden = true
        self.parentCoordinator = coordinating
    }
    
    func start() {
        let vc = ApplicantVC()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension ApplicantCoordinator: ApplicantCoordinating {
    func call(model: [MatchedSpeaker]?) {
        parentCoordinator?.call(model: model)
    }
}

