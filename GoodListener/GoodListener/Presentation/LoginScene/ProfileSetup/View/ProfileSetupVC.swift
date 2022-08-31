//
//  ViewController.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/07/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class ProfileSetupVC: UIViewController, SnapKitType {
    
    weak var coordinator: LoginCoordinating?
    var disposeBag = DisposeBag()
    var viewModel = ProfileSetupViewModel()
    
    var selectedImage = BehaviorRelay<Int?>(value: nil)
    var signInObservable = PublishRelay<SignInModel>()
    
    var signInModel: SignInModel?
    
    let titleLbl = UILabel().then {
        $0.text = "프로필 설정하기"
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.bold, 20)
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
    }
    
    let contentsView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let imageContainer = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.8797428608, green: 0.8797428012, blue: 0.8797428608, alpha: 1)
        $0.layer.cornerRadius = 138 / 2
    }
    
    let profileImage = UIImageView().then {
        $0.layer.cornerRadius = 138 / 2
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    let editView = UIView().then {
        $0.backgroundColor = .m1
        $0.layer.cornerRadius = 43 / 2
    }
    
    let editImage = UIImageView().then {
        $0.image = UIImage(named: "ic_edit_btn")
    }
    
    let nicknameView = GLTextField(tag: 1).then {
        $0.title = "닉네임"
    }
    
    let introduceView = GLTextView(maxCount: 30).then {
        $0.contents = ""
        $0.title = "소개글"
    }
    
    let completeBtnContainer = UIView().then {
        $0.backgroundColor = .white
    }
    
    let completeButton = GLButton().then {
        $0.title = "완료"
        $0.configUI(.deactivate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    
    func addComponents() {
        [titleLbl, scrollView, completeBtnContainer].forEach { view.addSubview($0) }
        scrollView.addSubview(contentsView)
        [imageContainer, nicknameView, introduceView].forEach { contentsView.addSubview($0) }
        [profileImage, editView].forEach { imageContainer.addSubview($0) }
        editView.addSubview(editImage)
        completeBtnContainer.addSubview(completeButton)
    }
    
    func setConstraints() {
        titleLbl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLbl.snp.bottom).offset(22)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(completeBtnContainer.snp.top)
        }
        
        contentsView.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.edges.equalToSuperview()
        }
        
        imageContainer.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(138)
        }
        
        profileImage.snp.makeConstraints {
            $0.center.size.equalToSuperview()
        }
        
        editView.snp.makeConstraints {
            $0.right.bottom.equalToSuperview()
            $0.size.equalTo(43)
        }
        
        editImage.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(22)
            $0.center.equalToSuperview()
        }
        
        nicknameView.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(62)
            $0.left.right.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(Const.glTfHeight)
        }
        
        introduceView.snp.makeConstraints {
            $0.top.equalTo(nicknameView.snp.bottom).offset(30)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(introduceView.glTextViewHeight(textViewHeight: 62))
            $0.bottom.equalToSuperview()
        }
        
        completeBtnContainer.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(108)
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(30)
            $0.width.equalTo(Const.glBtnWidth)
            $0.height.equalTo(Const.glBtnHeight)
            $0.centerX.equalToSuperview()
        }
    }
    
    func bind() {
        let output = viewModel.transform(input: ProfileSetupViewModel.Input(profileImage: selectedImage,
                                                                            nickname: nicknameView.inputTf.rx.text.orEmpty.asObservable(),
                                                                            checkDuplicate: nicknameView.checkBtn.rx.tap.asObservable(),
                                                                            signIn: signInObservable.asObservable()))
        // 닉네임 유효성 검사결과에 따른 중복확인 버튼 UI변경
        output.nicknameValidationResult
            .emit(onNext: { [weak self] result in
                if result {
                    self?.nicknameView.descriptionLbl.text = "*한글/영문 + 숫자로 10글자까지 가능합니다"
                    self?.nicknameView.descriptionLbl.textColor = .f4
                    self?.nicknameView.checkBtn.titleColor = .m1
                    self?.nicknameView.tfUnderLine.backgroundColor = .black
                    self?.nicknameView.checkBtn.isUserInteractionEnabled = true
                } else {
                    if self?.nicknameView.inputTf.text?.count == 0 {
                        self?.nicknameView.descriptionLbl.text = "닉네임을 입력해주세요."
                    } else if self?.nicknameView.inputTf.text?.count ?? 0 > 10{
                        self?.nicknameView.descriptionLbl.text = "1자~10자 이내의 닉네임을 입력해주세요."
                    } else {
                        self?.nicknameView.descriptionLbl.text = "특수문자, 공백을 제외한  닉네임을 입력해주세요."
                    }
                    self?.nicknameView.tfUnderLine.backgroundColor = .error
                    self?.nicknameView.descriptionLbl.textColor = .error
                    self?.nicknameView.checkBtn.titleColor = .f4
                    self?.nicknameView.checkBtn.isUserInteractionEnabled = false
                }
            })
            .disposed(by: disposeBag)

        output.nicknameDuplicateResult
            .skip(1)
            .emit(onNext: { [weak self] (nickname, result) in
                guard let self = self else { return }
                self.view.endEditing(true)
                // fasle: 중복확인 성공
                self.nicknameDuplicateResultPopup(result)
                if !result {
                    // 성공팝업
                    // TODO: 중복확인 버튼 어떻게 처리?
                    self.signInModel?.nickname = nickname
                }
            })
            .disposed(by: disposeBag)

        output.canComplete
            .emit(onNext: { [weak self] result in
                if result {
                    self?.completeButton.configUI(.active)
                } else {
                    self?.completeButton.configUI(.deactivate)
                }
            })
            .disposed(by: disposeBag)
        
        output.signInSuccess
            .emit(onNext: { [weak self] result in
                if result {
                    self?.coordinator?.completeJoin()
                } else {
                    // 회원가입 실패
                }
            })
            .disposed(by: disposeBag)

        // 프로필 이미지 Edit버튼 터치 시 프로필이미지선택 팝업을 띄워준다
        editView.tapGesture
            .subscribe(onNext: { [weak self] _ in
                let view = ProfileImageSelectView()
                self?.view.addSubview(view)
                view.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }

                // 팝업에서 선택된 이미지를 현재 프로필이미지에 반영
                view.selectedImage
                    .subscribe(onNext: { [weak self] image in
                        self?.profileImage.image = UIImage(named: "profile\(UserDefaultsManager.shared.profileImg)")
                        self?.signInModel?.profileImg = image ?? 1
                        self?.selectedImage.accept(image)
                    })
                    .disposed(by: view.disposeBag)

            })
            .disposed(by: disposeBag)

        // 완료버튼 클릭
        completeButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.signInModel?.description = self.introduceView.contents
                self.signInObservable.accept(self.signInModel!)
//                self.coordinator?.completeJoin(model: self.signInModel!)
            })
            .disposed(by: disposeBag)
        
        Observable.of(contentsView.tapGesture, scrollView.tapGesture, completeBtnContainer.tapGesture)
            .merge()
            .bind(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
    
    // 중복 확인 팝업
    func nicknameDuplicateResultPopup(_ result: Bool) {
        let popup = GLPopup()
        if !result {
            popup.title = "회원 가입"
            popup.contents = "사용 가능한 닉네임이에요"
        } else {
            popup.title = "닉네임 중복 확인"
            popup.contents = "닉네임 중복 확인을 해주세요"
        }
        popup.cancelIsHidden = true
        popup.alignment = .center
        view.addSubview(popup)
        popup.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification:NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
    }


    @objc func keyboardWillHide(_ notification:NSNotification) {
        guard let _ = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        self.view.transform = .identity
    }


}
