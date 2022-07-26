//
//  MyPageViewController.swift
//  GoodListener
//
//  Created by cheonsong on 2022/07/26.
//

import UIKit
import RxSwift
import RxCocoa

class MyPageViewController: UIViewController {

    weak var coordinator: MyPageCoordinating?
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.text = "MyPage"
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("로그아웃", for: .normal)
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.top.centerX.equalToSuperview()
        }
        
        view.backgroundColor = .white
        
        // 로그아웃 예제
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                Log.d("Logout")
                self?.coordinator?.logout()
            })
            .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
