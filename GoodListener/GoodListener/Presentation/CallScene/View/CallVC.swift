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
    
    let manager = CallManager(appID: AgoraConfiguration.appID)
    let disposeBag = DisposeBag()
    
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
        $0.font = FontManager.shared.notoSansKR(.regular, 20)
        $0.textColor = .white
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
        $0.axis = .vertical
        $0.backgroundColor = .clear
        $0.spacing = 20
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
    
    let extendButton = GLButton().then {
        $0.title = "연장 요청하기\n(5분)"
        $0.titleLabel?.lineBreakMode = .byWordWrapping
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.textFontChange(text: $0.titleLabel!.text!, font: FontManager.shared.notoSansKR(.regular, 10), range: "(5분)")
    }
    
    let stopButton = GLButton().then {
        $0.title = "종료"
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
    }
    
    let remainNoticeLabel = UILabel().then {
        $0.text = "통화 종료까지 1분 남았습니다\n연장을 원하시면 연장을 요청하세요"
        $0.font = FontManager.shared.notoSansKR(.regular, 10)
        $0.textColor = .f4
        $0.numberOfLines = 0
    }
    
    let noticeLabel = UILabel().then {
        $0.text = "시간 연장 시, 상대방의 동의를 구한 후 연장해주세요"
        $0.font = FontManager.shared.notoSansKR(.regular, 10)
        $0.textColor = .f4
        $0.numberOfLines = 0
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
        [titleStackView, profileImage, nickName, buttonStackView].forEach { view.addSubview($0) }
        [titleLabel, timeLabel, remainNoticeLabel].forEach { titleStackView.addArrangedSubview($0) }
        [extendButton, noticeLabel, stopButton, acceptButton, refuseButton].forEach { buttonStackView.addArrangedSubview($0) }
    }
    
    func setConstraints() {
        titleStackView.snp.makeConstraints {
            $0.bottom.equalTo(profileImage.snp.top).offset(-90)
            $0.left.equalToSuperview().inset(Const.padding)
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
            $0.width.equalTo(200)
            $0.centerX.equalToSuperview()
        }
        
        acceptButton.snp.makeConstraints {
            $0.height.equalTo(Const.glBtnHeight)
        }
        
        refuseButton.snp.makeConstraints {
            $0.height.equalTo(Const.glBtnHeight)
        }
        
        extendButton.snp.makeConstraints {
            $0.height.equalTo(Const.glBtnHeight)
        }
        
        stopButton.snp.makeConstraints {
            $0.height.equalTo(Const.glBtnHeight)
        }
    }
    
    func bind() {
        acceptButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.changeUI(.call)
            })
            .disposed(by: disposeBag)
        
        refuseButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        extendButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.changeUI(.remain)
            })
            .disposed(by: disposeBag)
        
        stopButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.dismiss(animated: true)
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
            noticeLabel.isHidden = true
            remainNoticeLabel.isHidden = true
            break
        case .call:
            titleLabel.text = "통화 하는 중"
            timeLabel.isHidden = false
            extendButton.isHidden = false
            stopButton.isHidden = false
            acceptButton.isHidden = true
            refuseButton.isHidden = true
            noticeLabel.isHidden = false
            remainNoticeLabel.isHidden = true
            break
        case .remain:
            titleLabel.text = "통화 하는 중"
            timeLabel.isHidden = false
            extendButton.isHidden = false
            stopButton.isHidden = false
            acceptButton.isHidden = true
            refuseButton.isHidden = true
            noticeLabel.isHidden = false
            remainNoticeLabel.isHidden = false
            break
        }
    }

}
