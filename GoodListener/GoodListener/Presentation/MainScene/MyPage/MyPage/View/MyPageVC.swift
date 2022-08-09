//
//  MyPageViewController.swift
//  GoodListener
//
//  Created by cheonsong on 2022/07/26.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class MyPageVC: UIViewController, SnapKitType {

    weak var coordinator: MyPageCoordinating?
    var disposeBag = DisposeBag()
    
    let settingIco = UIButton().then {
        $0.setImage(UIImage(named: "ic_navi_setting_dark"), for: .normal)
    }
    
    let profileImage = UIImageView().then {
        $0.image = UIImage(named: "main_img_step_01")
        $0.layer.cornerRadius = 50
        $0.layer.masksToBounds = true
    }
    
    let nicknameContainer = UIView().then {
        $0.backgroundColor = .m3
        $0.layer.cornerRadius = 6
    }
    
    let nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f6
    }
    
    let nicknameTf = UITextField().then {
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f3
        $0.text = "닉네임~~"
        $0.textAlignment = .center
    }
    
    let tagContainer = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let tagLabel = UILabel().then {
        $0.text = "나의 태그"
        $0.font = FontManager.shared.notoSansKR(.bold, 14)
        $0.textColor = .f4
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        addComponents()
        setConstraints()
        bind()
    }
    
    func addComponents() {
        [settingIco, profileImage, nicknameContainer, tagContainer].forEach { view.addSubview($0) }
        [nicknameLabel, nicknameTf].forEach { nicknameContainer.addSubview($0) }
        [tagLabel].forEach { tagContainer.addSubview($0) }
    }
    
    func setConstraints() {
        settingIco.snp.makeConstraints {
            $0.right.equalToSuperview().inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        profileImage.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.bottom.equalTo(nicknameContainer.snp.top).offset(-28)
            $0.centerX.equalToSuperview()
        }
        
        nicknameContainer.snp.makeConstraints {
            $0.width.equalTo(Const.glBtnWidth)
            $0.height.equalTo(Const.glBtnHeight)
            $0.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
        
        nicknameTf.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(nicknameLabel).offset(16)
            $0.right.equalToSuperview().inset(16)
        }
        
        tagContainer.snp.makeConstraints {
            $0.top.equalTo(nicknameContainer.snp.bottom).offset(50)
            $0.height.equalTo(30)
            $0.left.right.equalToSuperview().inset(Const.padding)
        }
        
        tagLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
        }
    }
    
    func bind() {
        
    }

}
