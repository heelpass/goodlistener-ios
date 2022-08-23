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
    case fail
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
        $0.spacing = 18
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
    
    let subTitleLabel = UILabel().then {
        $0.text = "오늘은 대화가 힘드신 것 같아요\n우리 내일 같은 시간에 다시 대화해요"
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
        $0.textColor = .m5
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.isHidden = true
    }
    
    let timeLabel = UILabel().then {
        $0.text = "0:00 / 3:00"
        $0.font = FontManager.shared.notoSansKR(.bold, 40)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.sizeToFit()
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
    
    let acceptButton = GLButton(type: .rectangle).then {
        $0.title = "전화 받기"
    }
    
    let refuseButton = GLButton(type: .rectangle).then {
        $0.title = "다음에 받기"
        $0.backgroundColor = .m2
    }
    
    let okayBtn = GLButton(type: .round).then {
        $0.title = "네, 알겠어요"
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
        [titleStackView, profileImage, nickName, buttonStackView, stopButton, okayBtn].forEach { view.addSubview($0) }
        [titleLabel, timeLabel, subTitleLabel].forEach { titleStackView.addArrangedSubview($0) }
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
        
        okayBtn.snp.makeConstraints {
            $0.height.equalTo(Const.glBtnHeight)
            $0.width.equalTo(200)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nickName.snp.bottom).offset(90)
        }
        
        stopButton.snp.makeConstraints {
            $0.top.equalTo(nickName.snp.bottom).offset(82)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(240)
            $0.height.equalTo(64)
        }
    }
    
    func bind() {
        // 통화 수락
        acceptButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.changeUI(.call)
                // 소켓
            })
            .disposed(by: disposeBag)
        
        // 통화 거절
        refuseButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.changeUI(.fail)
            })
            .disposed(by: disposeBag)
        
        // 통화 중지
        stopButton.swipeSuccessResult
            .filter { $0 }
            .bind(onNext: { [weak self] _ in
                self?.coordinator?.moveToReview()
            })
            .disposed(by: disposeBag)
        
        // 통화 연결 실패 시 오케이버튼
        okayBtn.rx.tap
            .bind(onNext: { [weak self] in
                self?.coordinator?.moveToMain()
            })
            .disposed(by: disposeBag)
    }
    
    func changeUI(_ type: CallState) {
        switch type {
        case .ready:
            // Title
            timeLabel.isHidden = true
            subTitleLabel.isHidden = true
            
            // Btn
            acceptButton.isHidden = false
            refuseButton.isHidden = false
            okayBtn.isHidden = true
            stopButton.isHidden = true
            
        case .call:
            // Title
            titleLabel.text = "리스너와 대화중이에요"
            titleLabel.font = FontManager.shared.notoSansKR(.regular, 20)
            titleLabel.textAlignment = .center
            timeLabel.isHidden = false
            timeLabel.textAlignment = .center
            subTitleLabel.isHidden = true
            
            // Btn
            acceptButton.isHidden = true
            refuseButton.isHidden = true
            okayBtn.isHidden = true
            stopButton.isHidden = false
            
        case .fail:
            // Title
            titleLabel.text = "리스너와 통화에 실패했어요 :("
            titleLabel.font = FontManager.shared.notoSansKR(.bold, 20)
            titleLabel.textAlignment = .center
            timeLabel.isHidden = true
            subTitleLabel.isHidden = false
            
            // Btn
            stopButton.isHidden = true
            acceptButton.isHidden = true
            okayBtn.isHidden = false
            refuseButton.isHidden = true
            break
        }
    }

}
