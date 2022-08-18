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
    func moveToPersonalInfoPage() // 개인정보 입력 페이지
    func moveToNicknameSetPage(model: UserInfo) // 닉네임 설정 페이지
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
        let vc = LoginVC()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension LoginCoordinator: LoginCoordinating {
    // 본인인증 페이지로 이동
    func moveToAuthCheck() {
        let vc = AuthVC()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    // 로그인에 성공한 경우 메인으로 이동
    func loginSuccess() {
        parentCoordinatorDelegate?.moveToMain()
    }
    
    // 로그인 페이지로 이동
    func moveToLoginPage() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func moveToPersonalInfoPage() {
        let vc = PersonalInfoVC()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func moveToNicknameSetPage(model: UserInfo) {
        let vc = NicknameSetupVC()
        vc.coordinator = self
        vc.userInfo = model
        navigationController.pushViewController(vc, animated: true)
    }
    
    
}
