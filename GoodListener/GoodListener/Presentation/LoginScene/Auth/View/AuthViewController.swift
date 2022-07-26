//
//  AuthViewController.swift
//  GoodListener
//
//  Created by cheonsong on 2022/07/26.
//

import UIKit
import SnapKit
import RxGesture
import RxSwift

class AuthViewController: UIViewController {
    
    weak var coordinator: LoginCoordinating?
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let label = UILabel()
        label.text = "본인인증"
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        let button = UIButton()
        button.setTitle("뒤로가기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.centerX.top.equalTo(view.safeAreaLayoutGuide)
            $0.size.equalTo(100)
        }
        // Do any additional setup after loading the view.
        
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.moveToLoginPage()
            })
            .disposed(by: disposeBag)
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
