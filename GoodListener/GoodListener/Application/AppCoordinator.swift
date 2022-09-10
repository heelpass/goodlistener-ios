//
//  AppCoordinator.swift
//  GoodListener
//
//  Created by cheonsong on 2022/07/26.
//

import Foundation
import UIKit

protocol AppCoordinating: AnyObject {
    func moveToMain()
}

class AppCoordinator: CoordinatorType {
    
    var childCoordinators: [CoordinatorType] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // 기본적으로 앱이 실행되면 Login화면을 띄워준다
        let child = LoginCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        child.parentCoordinatorDelegate = self
        childCoordinators.append(child)
        child.start()
        
        if UserDefaultsManager.shared.isLogin == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.moveToMain()
                Log.d("Main Scene Start")
            })
        }
    }
}

extension AppCoordinator: AppCoordinating {
    
    // 로그인에 성공한 경우 Login페이지를 내리고 메인화면(TabBar)을 올려준다
    func moveToMain() {
        let child = MainCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
}
