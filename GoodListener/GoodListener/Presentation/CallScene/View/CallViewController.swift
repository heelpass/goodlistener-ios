//
//  CallViewController.swift
//  GoodListener
//
//  Created by cheonsong on 2022/07/28.
//

import UIKit
import AgoraRtcKit
import Then
import RxSwift
import RxCocoa
import RxGesture
import SnapKit

class CallViewController: UIViewController {
    
    let manager = CallManager(appID: AgoraConfiguration.appID)
    let disposeBag = DisposeBag()
    
    let titleLabel = UILabel().then {
        $0.text = "Call Test"
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 50)
    }
    
    let startButton = UIButton().then {
        $0.setTitle("start", for: .normal)
        $0.backgroundColor = .black
    }
    
    let stopButton = UIButton().then {
        $0.setTitle("stop", for: .normal)
        $0.backgroundColor = .red
    }
    
    let backButton = UIButton().then {
        $0.setTitle("back", for: .normal)
        $0.backgroundColor = .blue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        [titleLabel, startButton, stopButton, backButton].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(200)
            $0.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(75)
            $0.center.equalToSuperview()
        }
        
        stopButton.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(75)
            $0.top.equalTo(startButton.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(75)
            $0.top.equalTo(stopButton.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        startButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.manager.start()
            })
            .disposed(by: disposeBag)
        
        stopButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.manager.stop()
            })
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }

}
