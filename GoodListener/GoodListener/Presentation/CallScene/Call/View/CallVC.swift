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

enum CallState {
    case ready
    case call
    case remain
}

class CallVC: UIViewController, SnapKitType {
    
    weak var coordinator: CallCoordinating?
    let manager = CallManager.shared
    let disposeBag = DisposeBag()
    
    // 현재 전화 상태
    var state: CallState = .ready
    
    let titleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .clear
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "당신의 리스너에게서\n전화가 왔어요   "
        label.textAlignment = .left
        label.font = FontManager.shared.notoSansKR(.bold, 26)
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = .white
        
        let attr = NSMutableAttributedString(string: label.text!)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "call_img_call")
        attr.append(NSAttributedString(attachment: imageAttachment))
        
        label.attributedText = attr
        return label
    }()
    
    let timeLabel = UILabel().then {
        $0.text = "0:00 / 3:00"
        $0.font = FontManager.shared.notoSansKR(.bold, 40)
        $0.textColor = .white
        $0.textAlignment = .left
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
    
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = .clear
        $0.spacing = 20
        $0.distribution = .fillEqually
    }
    
    let acceptButton = GLButton(frame: .zero, type: .rectangle).then {
        $0.title = "전화 받기"
    }
    
    let refuseButton = GLButton(frame: .zero, type: .rectangle).then {
        $0.title = "다음에 받기"
        $0.backgroundColor = .m2
    }
    
    let stopButton = SwipeButton().then {
        $0.isHidden = true
        $0.backgroundColor = .clear
    }
    
    let extendButton = GLButton().then {
        $0.title = "연장 요청하기\n(5분)"
        $0.titleLabel?.lineBreakMode = .byWordWrapping
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.textFontChange(text: $0.titleLabel!.text!, font: FontManager.shared.notoSansKR(.regular, 10), range: "(5분)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.1971904635, green: 0.2260227799, blue: 0.1979919374, alpha: 1)
        // Do any additional setup after loading the view.
        addComponents()
        setConstraints()
        bind()
        changeUI(.ready)
    }
    
    func addComponents() {
        [titleStackView, profileImage, nickName, buttonStackView, stopButton].forEach { view.addSubview($0) }
        [titleLabel, timeLabel].forEach { titleStackView.addArrangedSubview($0) }
        [refuseButton, acceptButton].forEach { buttonStackView.addArrangedSubview($0) }
    }
    
    func setConstraints() {
        titleStackView.snp.makeConstraints {
            $0.bottom.equalTo(profileImage.snp.top).offset(-90)
            $0.left.right.equalToSuperview().inset(Const.padding)
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
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(nickName.snp.bottom).offset(90)
            $0.left.right.equalToSuperview().inset(Const.padding)
        }
        
        acceptButton.snp.makeConstraints {
            $0.height.equalTo(Const.glBtnHeight)
        }
        
        refuseButton.snp.makeConstraints {
            $0.height.equalTo(Const.glBtnHeight)
        }
        
        stopButton.snp.makeConstraints {
            $0.top.equalTo(nickName.snp.bottom).offset(82)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(240)
            $0.height.equalTo(64)
        }
    }
    
    func bind() {
        acceptButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.changeUI(.call)
                // 소켓
            })
            .disposed(by: disposeBag)
        
        refuseButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.coordinator?.moveToMain()
            })
            .disposed(by: disposeBag)
        
        extendButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.changeUI(.remain)
                // 통화시간 연장
            })
            .disposed(by: disposeBag)
        
        stopButton.swipeSuccessResult
            .filter { $0 }
            .bind(onNext: { [weak self] _ in
                self?.coordinator?.moveToReview()
            })
            .disposed(by: disposeBag)
    }
    
    func changeUI(_ type: CallState) {
        switch type {
        case .ready:
            timeLabel.isHidden = true
            acceptButton.isHidden = false
            refuseButton.isHidden = false
            extendButton.isHidden = true
            stopButton.isHidden = true
            break
        case .call:
            titleLabel.text = "리스너와 대화중이에요"
            titleLabel.font = FontManager.shared.notoSansKR(.regular, 20)
            titleLabel.textAlignment = .center
            timeLabel.isHidden = false
            timeLabel.textAlignment = .center
            extendButton.isHidden = false
            stopButton.isHidden = false
            acceptButton.isHidden = true
            refuseButton.isHidden = true
            stopButton.isHidden = false
            break
        case .remain:
            titleLabel.text = "통화 하는 중"
            timeLabel.isHidden = false
            extendButton.isHidden = false
            stopButton.isHidden = false
            acceptButton.isHidden = true
            refuseButton.isHidden = true
            break
        }
    }

}
