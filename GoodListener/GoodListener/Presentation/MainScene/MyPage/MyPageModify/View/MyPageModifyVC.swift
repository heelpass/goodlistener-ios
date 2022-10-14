//
//  MyPageTagVC.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/11.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MyPageModifyVC: UIViewController, SnapKitType {
 
    weak var coordinator: MyPageCoordinating?
    var disposeBag = DisposeBag()
    static let borderColor = UIColor(red: 241/255, green: 243/255, blue: 244/255, alpha:1)
    let viewModel = MyPageModifyViewModel()
    
    let navigationView = NavigationView(frame: .zero, type: .save).then {
        $0.logo.isHidden = true
        $0.backBtn.isHidden = false
        $0.title.isHidden = false
        $0.title.text = "나의 정보 수정"
    }
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
    }
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .clear
    }
    
    let nicknameView = GLTextField(tag: 1, isShowDescription: true).then {
        $0.title = "닉네임"
        $0.inputTf.text = UserDefaultsManager.shared.nickname
    }
    
    let genderTagView = TagView(data: TagList.sexList, isEditable: false).then {
        $0.title.text = "성별"
        $0.selectedTag.accept(UserDefaultsManager.shared.gender!)
    }
    
    let ageTagView = TagView(data: TagList.ageList, isEditable: false).then {
        $0.title.text = "연령대"
        $0.selectedTag.accept(UserDefaultsManager.shared.age!)
    }
    
    let jobTagView = TagView(data: TagList.jobList).then {
        $0.title.text = "하는 일"
        $0.selectedTag.accept(UserDefaultsManager.shared.job!)
        $0.line.isHidden = true
    }
    
    let introduceView = GLTextView(maxCount: 30).then {
        $0.title = "소개글"
        $0.contents = UserDefaultsManager.shared.description!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addComponents()
        setDoneBtn()
        setConstraints()
        bind()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
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
        [navigationView, scrollView].forEach { view.addSubview($0) }
        scrollView.addSubview(stackView)
        [nicknameView, genderTagView, ageTagView, jobTagView, introduceView].forEach { stackView.addArrangedSubview($0) }
    }
    
    func setConstraints() {
        let width = UIScreen.main.bounds.width
        
        navigationView.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        scrollView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(navigationView.snp.bottom).offset(40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(width)
        }
        
        stackView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
            $0.width.equalTo(width)
        }
        
        nicknameView.snp.makeConstraints {
            $0.width.equalTo(width)
            $0.height.equalTo(Const.glTfHeight)
        }
        
        stackView.setCustomSpacing(11, after: nicknameView)
        
        genderTagView.snp.makeConstraints {
            $0.width.equalTo(width)
            $0.height.equalTo(genderTagView.tagCollectionViewHeight())
        }
        
        ageTagView.snp.makeConstraints {
            $0.width.equalTo(width)
            $0.height.equalTo(ageTagView.tagCollectionViewHeight())
        }
        
        jobTagView.snp.makeConstraints {
            $0.width.equalTo(width)
            $0.height.equalTo(jobTagView.tagCollectionViewHeight())
        }
        
        stackView.setCustomSpacing(19, after: jobTagView)
        
        introduceView.snp.makeConstraints {
            $0.height.equalTo(introduceView.glTextViewHeight(textViewHeight: 62))
            $0.width.equalTo(width)
        }
    }
    
    func bind() {
        let output = viewModel.transform(input: MyPageModifyViewModel.Input(nickname: nicknameView.inputTf.rx.text.orEmpty.asObservable(),
                                                                            job: jobTagView.selectedTag.asObservable(),
                                                                            introduce: introduceView.contentsObservable,
                                                                            checkDuplicate: nicknameView.checkBtn.rx.tap.asObservable(),
                                                                            saveBtnTap: navigationView.rightBtn.rx.tap.asObservable()))
        
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
            })
            .disposed(by: disposeBag)
        
        output.popupMessage
            .emit(onNext: { [weak self] message in
                guard let self = self else { return }
                
                let popup = GLPopup()
                popup.title = "알림"
                popup.contents = message
                popup.cancelIsHidden = true
                popup.alignment = .center
                
                self.view.addSubview(popup)
                popup.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
                
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
            
        navigationView.backBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // 중복 확인 팝업
    func nicknameDuplicateResultPopup(_ result: Bool) {
        let popup = GLPopup()
        if !result {
            popup.title = "닉네임 중복 확인"
            popup.contents = PopupMessage.nicknameCheckYes
        } else {
            popup.title = "닉네임 중복 확인"
            popup.contents = PopupMessage.nicknameCheckNo
        }
        popup.cancelIsHidden = true
        popup.alignment = .center
        
        self.tabBarController?.view.addSubview(popup)
        popup.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //키보드 상단 완료 버튼
    func setDoneBtn() {
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(dismissMyKeyboard))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        self.nicknameView.inputTf.inputAccessoryView = toolbar
        self.introduceView.contentsTv.inputAccessoryView = toolbar
    }
    
    
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification:NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        UIView.animate(withDuration: 0.2, animations: {
            [self.genderTagView,
             self.ageTagView,
             self.jobTagView].forEach { $0.isHidden = true }
        })
        
    }


    @objc func keyboardWillHide(_ notification:NSNotification) {
        guard let _ = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        UIView.animate(withDuration: 0.2, animations: {
            [self.genderTagView,
             self.ageTagView,
             self.jobTagView].forEach { $0.isHidden = false }
        })
    }
}
