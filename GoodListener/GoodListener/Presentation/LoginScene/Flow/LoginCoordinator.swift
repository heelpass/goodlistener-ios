//
//  LoginCoordinator.swift
//  GoodListener
//
//  Created by cheonsong on 2022/07/26.
//

import Foundation
import UIKit

protocol LoginCoordinating: AnyObject {
    func loginSuccess()     // 로그인에 성공한 경우
    func moveToLoginPage()  // 로그인페이지로 이동
    func moveToPersonalInfoPage(model: SignInModel) // 개인정보 입력 페이지
    func moveToNicknameSetPage(model: SignInModel) // 닉네임 설정 페이지
    func completeJoin() // 회원가입완료
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
    
    // 로그인에 성공한 경우 메인으로 이동
    func loginSuccess() {
        parentCoordinatorDelegate?.moveToMain()
    }
    
    // 로그인 페이지로 이동
    func moveToLoginPage() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func moveToPersonalInfoPage(model: SignInModel) {
        let vc = PersonalInfoVC()
        vc.coordinator = self
        vc.signInModel = model
        navigationController.pushViewController(vc, animated: true)
    }
    
    func moveToNicknameSetPage(model: SignInModel) {
        let vc = ProfileSetupVC()
        vc.coordinator = self
        vc.signInModel = model
        navigationController.pushViewController(vc, animated: true)
    }
    
    func completeJoin() {
        moveToLoginPage()
        loginSuccess()
    }
    
}
