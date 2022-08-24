//
//  ReviewVC.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/09.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

enum ReviewType {
    case day
    case week
}

class CallReviewVC: UIViewController, SnapKitType {
    
    var disposeBag = DisposeBag()
    weak var coordinator: CallCoordinating?
    let viewModel = CallReviewViewModel()
    
    // CallReviewVC 인스턴스를 생성후 type을 주입시키면 해당 UI로 변경됩니다!
    var type: ReviewType = .day {
        willSet {
            configUI(type: newValue)
        }
    }
    
    let titleLabel = UILabel().then {
        $0.text = "후기 남기기"
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.bold, 20)
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    let completeButton = GLButton().then {
        $0.title = "확인"
    }
    
    let moodContainer = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let moodTitle = UILabel().then {
        $0.text = "오늘 대화는 어땠나요?"
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f2
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    let moodView = MoodView()
    
    let reviewContainer = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let reviewTitle = UILabel().then {
        $0.text = "간단한 후기를 작성해주세요"
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f2
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    let reviewTv = UITextView().then {
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
        $0.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .m5
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.f6.cgColor
    }
    
    let reviewNoticeLabel = UILabel().then {
        $0.text = "*최대 50글자까지 가능합니다"
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.regular, 12)
        $0.textColor = .f4
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    let continueLabel = UILabel().then {
        $0.text = "리스너와 대화를 이어가시겠어요?"
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.bold, 20)
        $0.textColor = .f2
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = .clear
        $0.spacing = 19
        $0.distribution = .fillEqually
    }
    
    let toDoNextBtn = GLButton(type: .rectangle).then {
        $0.title = "다음에 하기"
        $0.backgroundColor = .m2
    }
    
    let reapplicationBtn = GLButton(type: .rectangle).then {
        $0.title = "재신청하기"
        $0.backgroundColor = .m1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addComponents()
        setConstraints()
        bind()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // keyboardWillShow, keyboardWillHide observer 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func addComponents() {
        [titleLabel, moodTitle, moodView, reviewContainer, buttonStackView, continueLabel].forEach { view.addSubview($0) }
        [reviewTitle, reviewTv, reviewNoticeLabel].forEach { reviewContainer.addSubview($0) }
        [toDoNextBtn, reapplicationBtn, completeButton].forEach { buttonStackView.addArrangedSubview($0) }
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
            $0.centerX.equalToSuperview()
        }
        
        moodTitle.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(44)
            $0.left.right.equalToSuperview().inset(Const.padding)
        }
        
        moodView.snp.makeConstraints {
            $0.top.equalTo(moodTitle.snp.bottom).offset(28)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(moodView.moodCollectionViewWidth())
            $0.height.equalTo(86)
        }
        
        reviewContainer.snp.makeConstraints {
            $0.top.equalTo(moodView.snp.bottom).offset(58)
            $0.left.right.equalToSuperview().inset(Const.padding)
        }
        
        reviewTitle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        reviewTv.snp.makeConstraints {
            $0.top.equalTo(reviewTitle.snp.bottom).offset(16)
            $0.height.equalTo(99)
            $0.left.right.equalToSuperview()
        }
        
        reviewNoticeLabel.snp.makeConstraints {
            $0.top.equalTo(reviewTv.snp.bottom).offset(2)
            $0.left.equalTo(reviewTv)
            $0.bottom.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(Const.padding)
            $0.bottom.equalToSuperview().inset(30)
            $0.height.equalTo(Const.glBtnHeight)
        }
        
        continueLabel.snp.makeConstraints {
            $0.bottom.equalTo(buttonStackView.snp.top).offset(-32)
            $0.centerX.equalToSuperview()
        }
    }
    
    func bind() {
        //TODO: 다음에하기, 재신청하기도 확인버튼과 동일하게 동작하는지 물어보고 수정필요
        let output = viewModel.transform(input: CallReviewViewModel.Input(reviewText: reviewTv.rx.text.orEmpty.asObservable(),
                                                                          moodTag: moodView.selectedTag,
                                                                          sendReview: completeButton.rx.tap.asObservable()))
        
        output.textValidationResult
            .emit(to: reviewTv.rx.text)
            .disposed(by: disposeBag)
        
        // 완료 -> 메인으로 이동
        completeButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.coordinator?.moveToMain()
            })
            .disposed(by: disposeBag)
        
        // 다음에하기 -> 메인으로 이동
        toDoNextBtn.rx.tap
            .bind(onNext: { [weak self] in
                self?.coordinator?.moveToMain()
            })
            .disposed(by: disposeBag)
        
        // TODO: 재신청하기 -> 신청페이지로 랜딩
        reapplicationBtn.rx.tap
            .bind(onNext: { [weak self] in
                
            })
            .disposed(by: disposeBag)
    }
    
    private func configUI(type: ReviewType) {
        switch type {
        case .day:
            titleLabel.text = "후기 남기기"
            moodTitle.text = "오늘 후기는 어땠나요?"
            toDoNextBtn.isHidden = true
            reapplicationBtn.isHidden = true
            completeButton.isHidden = false
            continueLabel.isHidden = true
        case .week:
            titleLabel.text = "7일간의 대화가 끝났어요!"
            moodTitle.text = "오늘 대화는 어땠나요?"
            toDoNextBtn.isHidden = false
            reapplicationBtn.isHidden = false
            completeButton.isHidden = true
            continueLabel.isHidden = false
        }
    }
    
    @objc func keyboardWillShow(_ notification:NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        [titleLabel, moodTitle, moodView].forEach {
            $0.isHidden = true
        }
        [reviewContainer].forEach {
            $0.transform = CGAffineTransform.init(translationX: 0, y: -reviewContainer.calculateTranslationY(keyboardHeight))
        }
    }


    @objc func keyboardWillHide(_ notification:NSNotification) {
        guard let _ = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        [titleLabel, moodTitle, moodView].forEach {
            $0.isHidden = false
        }
        [reviewContainer].forEach {
            $0.transform = .identity
        }
    }
}


