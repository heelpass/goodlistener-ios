//
//  LoginCoordinator.swift
//  GoodListener
//
//  Created by cheonsong on 2022/07/26.
//

import Foundation
import UIKit

protocol LoginCoordinating: AnyObject {
    func moveToAuthCheck()  // 본인인증 페이지로 이동
    func loginSuccess()     // 로그인에 성공한 경우
    func moveToLoginPage()  // 로그인페이지로 이동
}

class LoginCoordinator: CoordinatorType {
    
    var childCoordinators: [CoordinatorType] = []
    var navigationController: UINavigationController
    
    // parent: AppCoordinator
    weak var parentCoordinator: CoordinatorType?
    weak var parentCoordinatorDelegate: AppCoordinating?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
    }
    
    func start() {
        let vc = LoginViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension LoginCoordinator: LoginCoordinating {
    // 본인인증 페이지로 이동
    func moveToAuthCheck() {
        let vc = AuthViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    // 로그인에 성공한 경우 메인으로 이동
    func loginSuccess() {
        parentCoordinatorDelegate?.moveToMain()
    }
    
    // 로그인 페이지로 이동
    func moveToLoginPage() {
        navigationController.viewControllers.forEach {
            if $0 is LoginViewController {} else { navigationController.popViewController(animated: true) }
        }
    }
}
