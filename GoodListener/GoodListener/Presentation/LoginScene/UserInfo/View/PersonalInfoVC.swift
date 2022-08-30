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


class PersonalInfoVC: UIViewController, SnapKitType {
    
    weak var coordinator: LoginCoordinating?
    var disposeBag = DisposeBag()
    let viewModel = PersonalInfoViewModel()
    var signInModel: SignInModel?
    
    let titleLabel = UILabel().then {
        $0.text = "당신에 대해서 알려주세요"
        $0.textAlignment = .left
        $0.font = FontManager.shared.notoSansKR(.bold, 20)
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    let subtitleLabel = UILabel().then {
        $0.text = "리스너가 당신을 더 잘 이해할 수 있어요"
        $0.textColor = .f4
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
    }
    
    let nextButton = GLButton().then {
        $0.title = "다음"
        $0.configUI(.deactivate)
    }
    
    lazy var ageTagView = TagView(data: TagList.ageList).then {
        $0.title.text = "나이"
    }
    
    lazy var sexTagView = TagView(data: TagList.sexList).then {
        $0.title.text = "성별"
    }
    
    lazy var jobTagView = TagView(data: TagList.jobList).then {
        $0.title.text = "직업"
        $0.line.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addComponents()
        setConstraints()
        bind()
        view.backgroundColor = .white
    }
    
    func addComponents() {
        [titleLabel, subtitleLabel, nextButton, ageTagView, sexTagView, jobTagView].forEach { view.addSubview($0) }
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.width.equalTo(Const.glBtnWidth)
            $0.height.equalTo(Const.glBtnHeight)
            $0.centerX.equalToSuperview()
        }
        
        ageTagView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(ageTagView.tagCollectionViewHeight())
        }
        
        sexTagView.snp.makeConstraints {
            $0.top.equalTo(ageTagView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(sexTagView.tagCollectionViewHeight())
        }
        
        jobTagView.snp.makeConstraints {
            $0.top.equalTo(sexTagView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(jobTagView.tagCollectionViewHeight())
        }
    }
    
    func bind() {
        let output = viewModel.transform(input: PersonalInfoViewModel.Input(genderTag: sexTagView.selectedTag,
                                                                            ageTag: ageTagView.selectedTag,
                                                                            jobTag: jobTagView.selectedTag))
        
        output.canNext
            .emit(onNext: { [weak self] can in
                if can {
                    self?.nextButton.configUI(.active)
                } else {
                    self?.nextButton.configUI(.deactivate)
                }
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                
                var signInModel = SignInModel()
                signInModel.gender = self.viewModel.model.gender.value
                signInModel.ageRange = self.viewModel.model.age.value
                signInModel.job = self.viewModel.model.job.value
                
                self.coordinator?.moveToNicknameSetPage(model: signInModel)
            })
            .disposed(by: disposeBag)
    }
    
}
