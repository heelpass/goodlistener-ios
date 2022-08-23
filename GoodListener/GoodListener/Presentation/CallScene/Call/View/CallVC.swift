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
    
    let viewModel = CallViewModel()
    
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
    
    let acceptBtn = GLButton(type: .rectangle).then {
        $0.title = "전화 받기"
    }
    
    let refuseBtn = GLButton(type: .rectangle).then {
        $0.title = "다음에 받기"
        $0.backgroundColor = .m2
    }
    
    let okayBtn = GLButton(type: .round).then {
        $0.title = "네, 알겠어요"
    }
    
    let stopBtn = SwipeButton().then {
        $0.isHidden = true
        $0.backgroundColor = .clear
    }
    
    let popup = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.6)
    }
    
    let popupContainer = UIView().then {
        $0.backgroundColor = .m5
        $0.layer .cornerRadius = 10
    }
    
    let popupTitle = UILabel().then {
        $0.text = " 잠깐!\n오늘 대화를 하지 못하면\n리스너와의 7일중 1회가 차감됩니다.\n오늘 대화를 취소하시겠어요?"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f2
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let popupBtnStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    let delayBtn = GLButton(type: .rectangle, reverse: true).then {
        $0.title = "대화 미루기"
    }
    
    let cancelBtn = GLButton(type: .rectangle).then {
        $0.title = "종료"
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
        [titleStackView, profileImage, nickName, buttonStackView, stopBtn, okayBtn].forEach { view.addSubview($0) }
        [titleLabel, timeLabel, subTitleLabel].forEach { titleStackView.addArrangedSubview($0) }
        [refuseBtn, acceptBtn].forEach { buttonStackView.addArrangedSubview($0) }
        
        // 팝업
        popup.addSubview(popupContainer)
        [popupTitle, popupBtnStackView].forEach { popupContainer.addSubview($0) }
        [delayBtn, cancelBtn].forEach { popupBtnStackView.addArrangedSubview($0) }
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
        
        acceptBtn.snp.makeConstraints {
            $0.height.equalTo(Const.glBtnHeight)
        }
        
        refuseBtn.snp.makeConstraints {
            $0.height.equalTo(Const.glBtnHeight)
        }
        
        okayBtn.snp.makeConstraints {
            $0.height.equalTo(Const.glBtnHeight)
            $0.width.equalTo(200)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nickName.snp.bottom).offset(90)
        }
        
        stopBtn.snp.makeConstraints {
            $0.top.equalTo(nickName.snp.bottom).offset(82)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(240)
            $0.height.equalTo(64)
        }
        
        // 팝업
        popupContainer.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(Const.padding)
        }
        
        popupTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(33)
            $0.centerX.equalToSuperview()
        }
        
        popupBtnStackView.snp.makeConstraints {
            $0.height.equalTo(Const.glBtnHeight)
            $0.left.right.equalToSuperview().inset(Const.padding)
            $0.top.equalTo(popupTitle.snp.bottom).offset(37)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    func bind() {
        let output = viewModel.transform(input: CallViewModel.Input(acceptBtnTap: acceptBtn.rx.tap.asObservable(),
                                                                    refuseBtnTap: refuseBtn.rx.tap.asObservable(),
                                                                    stopBtnTap: stopBtn.rx.tap.asObservable(),
                                                                    delayBtnTap: delayBtn.rx.tap.asObservable()))
        
        // 통화 수락
        acceptBtn.rx.tap
            .bind(onNext: { [weak self] in
                self?.changeUI(.call)
                // 소켓
            })
            .disposed(by: disposeBag)
        
        // 통화 거절
        refuseBtn.rx.tap
            .bind(onNext: { [weak self] in
                self?.changeUI(.fail)
            })
            .disposed(by: disposeBag)
        
        // 통화 중지
        stopBtn.swipeSuccessResult
            .filter { $0 }
            .bind(onNext: { [weak self] _ in
                self?.coordinator?.moveToReview()
            })
            .disposed(by: disposeBag)
        
        // 통화 연결 실패 시 오케이버튼
        okayBtn.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.view.addSubview(self.popup)
                self.popup.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
            })
            .disposed(by: disposeBag)
        
        delayBtn.rx.tap
            .bind(onNext: {
                
            })
            .disposed(by: disposeBag)
        
        cancelBtn.rx.tap
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
            acceptBtn.isHidden = false
            refuseBtn.isHidden = false
            okayBtn.isHidden = true
            stopBtn.isHidden = true
            
        case .call:
            // Title
            titleLabel.text = "리스너와 대화중이에요"
            titleLabel.font = FontManager.shared.notoSansKR(.regular, 20)
            titleLabel.textAlignment = .center
            timeLabel.isHidden = false
            timeLabel.textAlignment = .center
            subTitleLabel.isHidden = true
            
            // Btn
            acceptBtn.isHidden = true
            refuseBtn.isHidden = true
            okayBtn.isHidden = true
            stopBtn.isHidden = false
            
        case .fail:
            // Title
            titleLabel.text = "리스너와 통화에 실패했어요 :("
            titleLabel.font = FontManager.shared.notoSansKR(.bold, 20)
            titleLabel.textAlignment = .center
            timeLabel.isHidden = true
            subTitleLabel.isHidden = false
            
            // Btn
            stopBtn.isHidden = true
            acceptBtn.isHidden = true
            okayBtn.isHidden = false
            refuseBtn.isHidden = true
            break
        }
    }

}
