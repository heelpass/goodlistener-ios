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
    
    let nicknameView = GLTextField(tag: 1, isShowDescription: true).then {
        $0.title = "닉네임"
        $0.inputTf.text = UserDefaultsManager.shared.nickname
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
        setConstraints()
        bind()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func addComponents() {
        [navigationView, nicknameView, jobTagView, introduceView].forEach { view.addSubview($0) }
    }
    
    func setConstraints() {
        navigationView.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        nicknameView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(navigationView.snp.bottom).offset(64)
            $0.height.equalTo(Const.glTfHeight)
        }
        
        jobTagView.snp.makeConstraints {
            $0.top.equalTo(nicknameView.snp.bottom).offset(11)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(jobTagView.tagCollectionViewHeight())
        }
        
        introduceView.snp.makeConstraints {
            $0.top.equalTo(jobTagView.snp.bottom).offset(19)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(introduceView.glTextViewHeight(textViewHeight: 62))
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
        
        view.addSubview(popup)
        popup.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
