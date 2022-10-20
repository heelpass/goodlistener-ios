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
    case failThreeTime
}

class CallVC: UIViewController, SnapKitType {
    
    weak var coordinator: CallCoordinating?
    let manager = CallManager.shared
    let disposeBag = DisposeBag()
    var model: [MatchedSpeaker]?
    var viewModel: CallViewModel!
    
    let userType: UserType = UserType.init(rawValue: UserDefaultsManager.shared.userType) ?? .speaker //
    
    // 현재 전화 상태
    var state: BehaviorRelay<CallState> = BehaviorRelay(value: .ready)
    
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
        label.textColor = .white
        
        let attr = NSMutableAttributedString(string: label.text!)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "call_img_call")
        attr.append(NSAttributedString(attachment: imageAttachment))
        
        label.attributedText = attr
        label.sizeToFit()
        return label
    }()
    
    let subTitleLabel = UILabel().then {
        $0.text = "오늘은 대화가 힘드신 것 같아요\n우리 내일 같은 시간에 다시 대화해요"
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
        $0.textColor = .m5
        $0.numberOfLines = 0
        $0.textAlignment = .left
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
    
    // Popup
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
    
    let popupDelayBtn = GLButton(type: .rectangle, reverse: true).then {
        $0.title = "대화 1회 미루기"
        $0.isHidden = true
    }
    
    let popupOkbtn = GLButton(type: .rectangle).then {
        $0.title = "확인"
        $0.isHidden = true
    }
    
    let callAgainBtn = GLButton(type: .rectangle).then {
        $0.title = "전화 다시걸기"
        $0.isHidden = true
    }
    
    let listenerOkBtn = GLButton(type: .rectangle).then {
        $0.title = "종료"
        $0.isHidden = true
    }
    
    let getAgoraTokenButton = UIButton().then {
        $0.setTitle("아고라", for: .normal)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GLSocketManager.shared.start()
        viewModel = CallViewModel(model: model)
        view.backgroundColor = #colorLiteral(red: 0.1971904635, green: 0.2260227799, blue: 0.1979919374, alpha: 1)
        // Do any additional setup after loading the view.
        addComponents()
        setConstraints()
        bind()
        
        // 상태값이 바뀌면 UI도 알아서 바뀜
        state.bind(onNext: { [weak self] state in
            self?.configUI(state)
        })
        .disposed(by: disposeBag)
        
        viewModel.model = model
    }
    
    func addComponents() {
        [titleStackView, profileImage, nickName, buttonStackView, stopBtn, okayBtn].forEach { view.addSubview($0) }
        [titleLabel, timeLabel, subTitleLabel].forEach { titleStackView.addArrangedSubview($0) }
        [refuseBtn, acceptBtn, callAgainBtn].forEach { buttonStackView.addArrangedSubview($0) }
        view.addSubview(listenerOkBtn)
        
        // 팝업
        popup.addSubview(popupContainer)
        [popupTitle, popupBtnStackView].forEach { popupContainer.addSubview($0) }
        [popupDelayBtn, popupOkbtn].forEach { popupBtnStackView.addArrangedSubview($0) }
//        view.addSubview(getAgoraTokenButton)
    }
    
    func setConstraints() {
        
//        getAgoraTokenButton.snp.makeConstraints {
//            $0.size.equalTo(100)
//            $0.top.equalTo(stopBtn.snp.bottom)
//            $0.centerX.equalToSuperview()
//        }
//
//        getAgoraTokenButton.rx.tap
//            .subscribe(onNext: {
//                GLSocketManager.shared.createAgoraToken()
//            })
//            .disposed(by: disposeBag)
        
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
            $0.height.equalTo(Const.glBtnHeight)
            $0.width.equalTo(Const.glBtnWidth)
            $0.centerX.equalToSuperview()
        }
        
        acceptBtn.snp.makeConstraints {
            $0.height.equalTo(Const.glBtnHeight)
        }
        
        refuseBtn.snp.makeConstraints {
            $0.height.equalTo(Const.glBtnHeight)
        }
        
        callAgainBtn.snp.makeConstraints {
            $0.height.equalTo(Const.glBtnHeight)
        }
        
        listenerOkBtn.snp.makeConstraints {
            $0.top.equalTo(nickName.snp.bottom).offset(90)
            $0.width.equalTo(Const.glBtnWidth)
            $0.height.equalTo(Const.glBtnHeight)
            $0.centerX.equalToSuperview()
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
                                                                    stopBtnTap: stopBtn.swipeSuccessResult.asObservable(),
                                                                    delayBtnTap: popupDelayBtn.rx.tap.asObservable(),
                                                                    state: state,
                                                                    callAgainBtnTap: callAgainBtn.rx.tap.asObservable()))
        
        // 통화 수락
        acceptBtn.rx.tap
            .bind(onNext: { [weak self] in
                self?.state.accept(.call)
                // 소켓
            })
            .disposed(by: disposeBag)
        
        // 통화 거절
        refuseBtn.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
//                self?.changeUI(.fail)
                self.view.addSubview(self.popup)
                self.popup.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
                self.popupDelayBtn.isHidden = false
            })
            .disposed(by: disposeBag)
        
        // 통화 중지
        stopBtn.swipeSuccessResult
            .bind(onNext: { [weak self] _ in
                self?.coordinator?.moveToMain()
            })
            .disposed(by: disposeBag)
        
        okayBtn.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.popupTitle.text = "잠깐!\n오늘 대화를 진행하지 못한 관계로\n리스너와의 7일중 1회가 차감됩니다."
                
                
            })
            .disposed(by: disposeBag)
        
        popupDelayBtn.rx.tap
            .bind(onNext: {[weak self] _ in
                self?.coordinator?.moveToMain()
            })
            .disposed(by: disposeBag)
        
        popupOkbtn.rx.tap
            .bind(onNext: { [weak self] in
                self?.coordinator?.moveToMain()
            })
            .disposed(by: disposeBag)
        
        callAgainBtn.rx.tap
            .bind(onNext: { [weak self] in
                //TODO: 다시 전화거는 로직
                self?.state.accept(.ready)
            })
            .disposed(by: disposeBag)
        
        listenerOkBtn.rx.tap
            .bind(onNext: { [weak self] in
                self?.coordinator?.moveToMain()
            })
            .disposed(by: disposeBag)
        
        output.readyOneMin
            .emit(onNext: { [weak self] in
                self?.state.accept(.fail)
            })
            .disposed(by: disposeBag)
        
        output.time
            .emit(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.callEnd
            .emit(onNext: { [weak self] in
                self?.coordinator?.moveToMain()
            })
            .disposed(by: disposeBag)
        
        output.callFailThreeTime
            .emit(onNext: { [weak self] in
                self?.state.accept(.failThreeTime)
            })
            .disposed(by: disposeBag)
        
        output.outputState
            .bind(to: state)
            .disposed(by: disposeBag)
    }
    
    func configUI(_ state: CallState) {
        switch userType {
        case .speaker:
            profileImage.image = UIImage(named: "profile1")
            self.nickName.text = UserDefaultsManager.shared.listenerName
            speakerChangeUI(state)
        case .listener:
            if let model = model?.first {
                profileImage.image = UIImage(named: "profile\(model.speaker.profileImg)")
                nickName.text = model.speaker.nickName
            } else {
                profileImage.image = UIImage(named: "profile1")
                nickName.text = "스피커"
            }
            
            listenerChangeUI(state)
        }
    }
    
    func listenerChangeUI(_ type: CallState) {
        switch type {
        case .ready:
            titleLabel.text = "스피커에게\n전화를 걸고 있습니다   "
            titleLabel.textAlignment = .left
            
            let attr = NSMutableAttributedString(string: titleLabel.text!)
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(named: "call_img_call")
            attr.append(NSAttributedString(attachment: imageAttachment))
            
            titleLabel.attributedText = attr
            titleLabel.sizeToFit()
            
            callAgainBtn.isHidden = false
            callAgainBtn.configUI(.deactivate)
            listenerOkBtn.isHidden = true
            
            timeLabel.isHidden = true
            subTitleLabel.isHidden = true
            
            // Btn
            acceptBtn.isHidden = true
            refuseBtn.isHidden = true
            okayBtn.isHidden = true
            stopBtn.isHidden = true
            
        case .call:
            titleLabel.text = "스피커와 대화중이에요"
            titleLabel.font = FontManager.shared.notoSansKR(.regular, 20)
            titleLabel.textAlignment = .center
            timeLabel.isHidden = false
            timeLabel.textAlignment = .center
            subTitleLabel.isHidden = true
            titleStackView.snp.updateConstraints {
                $0.bottom.equalTo(profileImage.snp.top).offset(-90)
            }
            titleStackView.spacing = 0
            
            // Btn
            callAgainBtn.isHidden = true
            listenerOkBtn.isHidden = true
            acceptBtn.isHidden = true
            refuseBtn.isHidden = true
            okayBtn.isHidden = true
            stopBtn.isHidden = false
        case .fail:
            titleLabel.text = "스피커와\n대화 연결에 실패하였습니다."
            titleLabel.font = FontManager.shared.notoSansKR(.bold, 26)
            titleLabel.textAlignment = .left
            timeLabel.isHidden = true
            subTitleLabel.isHidden = false
            subTitleLabel.text = "3분 이내 3회까지 다시 통화를 시도해주세요."
            titleStackView.snp.updateConstraints {
                $0.bottom.equalTo(profileImage.snp.top).offset(-57)
            }
            titleStackView.spacing = 20
            callAgainBtn.configUI(.active)
            callAgainBtn.isHidden = false
            listenerOkBtn.isHidden = true
            
        case .failThreeTime:
            titleLabel.text = "스피커와\n대화 연결에 실패하였습니다."
            titleLabel.font = FontManager.shared.notoSansKR(.bold, 26)
            titleLabel.textAlignment = .left
            timeLabel.isHidden = true
            subTitleLabel.isHidden = false
            subTitleLabel.text = "내일 다시 같은 시간에 전화해주세요!"
            titleStackView.snp.updateConstraints {
                $0.bottom.equalTo(profileImage.snp.top).offset(-57)
            }
            titleStackView.spacing = 20
            acceptBtn.isHidden = true
            refuseBtn.isHidden = true
            callAgainBtn.isHidden = true
            listenerOkBtn.isHidden = false
        }
    }
    
    func speakerChangeUI(_ type: CallState) {
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
            titleStackView.snp.updateConstraints {
                $0.bottom.equalTo(profileImage.snp.top).offset(-90)
            }
            titleStackView.spacing = 0
            
            // Btn
            acceptBtn.isHidden = true
            refuseBtn.isHidden = true
            okayBtn.isHidden = true
            stopBtn.isHidden = false
            
        case .fail:
            // Title
            titleLabel.text = "리스너의 전화 시도가\n모두 실패하였습니다 :("
            titleLabel.font = FontManager.shared.notoSansKR(.bold, 26)
            titleLabel.textAlignment = .left
            timeLabel.isHidden = true
            subTitleLabel.isHidden = false
            titleStackView.snp.updateConstraints {
                $0.bottom.equalTo(profileImage.snp.top).offset(-57)
            }
            titleStackView.spacing = 20
            
            // Btn
            stopBtn.isHidden = true
            acceptBtn.isHidden = true
            okayBtn.isHidden = false
            refuseBtn.isHidden = true
            break
            
        default:
            break
        }
    }

}
