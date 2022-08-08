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

class CallViewController: UIViewController, SnapKitType {
    
    let manager = CallManager(appID: AgoraConfiguration.appID)
    let disposeBag = DisposeBag()
    
    let titleLabel = UILabel().then {
        $0.text = "당신의 리스너에게서\n전화가 왔어요"
        $0.textAlignment = .left
        $0.font = FontManager.shared.notoSansKR(.bold, 26)
        $0.numberOfLines = 0
        $0.sizeToFit()
        $0.textColor = .white
    }
    
    let callIcon = UIImageView().then {
        $0.image = UIImage(named: "call_img_call")
    }
    
    let profileImage = UIImageView().then {
        $0.image = UIImage(named: "main_img_step_01")
        $0.layer.cornerRadius = 60
        $0.layer.masksToBounds = true
    }
    
    let nickName = UILabel().then {
        $0.text = "닉네임"
        $0.font = FontManager.shared.notoSansKR(.bold, 20)
        $0.textColor = .white
    }
    
    let acceptButton = GLButton().then {
        $0.title = "전화 받기"
    }
    
    let refuseButton = GLButton().then {
        $0.title = "지금은 못받아요"
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.1971904635, green: 0.2260227799, blue: 0.1979919374, alpha: 1)
        // Do any additional setup after loading the view.
        addComponents()
        setConstraints()
    }
    
    func addComponents() {
        [titleLabel, callIcon, profileImage, nickName, acceptButton, refuseButton].forEach { view.addSubview($0) }
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(profileImage.snp.top).offset(-90)
            $0.left.equalToSuperview().inset(Const.padding)
        }
        
        callIcon.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.bottom.equalTo(titleLabel).offset(-5)
            $0.right.equalTo(titleLabel).offset(-30)
        }
        
        profileImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
            $0.size.equalTo(120)
        }
        
        nickName.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImage.snp.bottom).offset(20)
        }
        
        acceptButton.snp.makeConstraints {
            $0.top.equalTo(nickName.snp.bottom).offset(90)
            $0.height.equalTo(Const.glBtnHeight)
            $0.width.equalTo(200)
            $0.centerX.equalToSuperview()
        }
        
        refuseButton.snp.makeConstraints {
            $0.top.equalTo(acceptButton.snp.bottom).offset(20)
            $0.height.equalTo(Const.glBtnHeight)
            $0.width.equalTo(200)
            $0.centerX.equalToSuperview()
        }
    }

}
