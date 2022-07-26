//
//  MainCoordinator.swift
//  GoodListener
//
//  Created by cheonsong on 2022/07/26.
//

import Foundation
import UIKit

// 모든 코디네이터는 Coordinating 프로토콜을 갖습니다. Delegate이라고 생각하시면 됩니다!
// 뷰컨트롤러는 Coordinator를 주입받는게 아니라 Coordinating을 주입받습니다!
// 뷰컨트롤러는 Coordinating을 통해 화면전환을 시도하게 되고, 뷰는 어떤식으로 화면전환이 일어나는지 알 수 없습니다!
protocol MainCoordinating: AnyObject {
    func logout()
}

enum UserType {
    case speaker
    case listener
}

class MainCoordinator: CoordinatorType {
    var childCoordinators: [CoordinatorType] = []
    
    // Parent Coordinator가 있는 경우에는 parentCoordinator를 주입해주세요!
    // AppCoordinator(parent) -> MainCoordinator(child)
    weak var parentCoordinator: CoordinatorType?
    
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    
    // 유저 타입도 AppCoordinator에서 주입해줘야 합니다
    var userType: UserType = .speaker
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        
        switch userType {
        case .speaker:
            speakerStart()
        case .listener:
            listenerStart()
        }
        
    }
    
    // 스피커인 경우 스피커 탭바 실행
    func speakerStart() {
        // 1️⃣ 탭별로 코디네이터 객체를 생성해주세요!
        // navigationController는 새로운 인스턴스로 생성해주세요
        // coordinating의존성을 주입해 주세요!
        let home = HomeCoordinator(coordinating: self)
        let myPage = MyPageCoordinator(coordinating: self)
        
        // 2️⃣ 탭바 컨트롤러에 하위 뷰컨트롤러를 추가해주세요!
        home.start()
        myPage.start()
        
        // 3️⃣ MainCoordrinator - childCoordinators 에 각각의 코디네이터를 추가해주세요!
        // 추가하지 않으면 메모리에 남지않고 사라져버립니다
        // ❗️주의 : 뷰컨을 내려주기전에 childCoordinators에서 해당 코디네이터를 remove 시켜주세요 remove 시키지 않으면 메모리 누수가 발생합니다!
        // CoordinatorType.childDidFinish(child: CoordinatorType) 함수를 사용하면 childCoordinators에서 원하는 Coodinator만 제거가 가능합니다!
        childCoordinators.append(home)
        childCoordinators.append(myPage)
        
        home.navigationController.tabBarItem = UITabBarItem(title: "홈", image: nil, tag: 0)
        myPage.navigationController.tabBarItem = UITabBarItem(title: "마이 페이지", image: nil, tag: 1)
        
        // 4️⃣ TabBarController.viewControllers에 각각코디네이터의 navigationController을 추가해주세요!
        tabBarController.viewControllers = [home.navigationController, myPage.navigationController]
        
        tabBarController.modalPresentationStyle = .fullScreen
        navigationController.present(tabBarController, animated: true)
    }
    
    // 리스너인경우 리스너 탭바 실행
    func listenerStart() {
        
    }
}

extension MainCoordinator: MainCoordinating {
    func logout() {
        // 탭바 컨트롤러를 Dismiss시킬것이기 때문에 childCoordinators에 있는 자식코디네이터를 모두 제거해줍니다
        childCoordinators.removeAll()
        parentCoordinator?.childDidFinish(self)
        tabBarController.dismiss(animated: true)
    }
}

