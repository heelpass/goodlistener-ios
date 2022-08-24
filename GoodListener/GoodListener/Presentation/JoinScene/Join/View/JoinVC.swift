//
//  JoinVC.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/08/21.
//

import UIKit
import RxSwift
import RxCocoa

class JoinVC: UIViewController, SnapKitType, UITextViewDelegate {

    weak var coordinator: JoinCoordinating?
    let disposeBag = DisposeBag()
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .m5
    }
    
    let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .clear
    }
    
    let titleLbl = UILabel().then {
        $0.text = "신청하기"
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.bold, 20)
        $0.textColor = .f2
    }
    
    let descriptionLbl = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "신청한 시간에 일정이 가능한 리스너가 매칭돼요\n 자세히 작성할수록 당신과 잘 맞는 리스너와\n만날 확률이 높아져요"
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f3
    }
    
    
    let questionOneLbl = UILabel().then {
        $0.text = "저는 이런 대화를 원해요"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f3
    }
    
    let emojiTagView = EmojiTagView(frame: .zero, emojiImgdata: EmojiTagList.emojiImgList, emojiTextdata: EmojiTagList.emojiTextList)
    
    
    let questionTwoLbl = UILabel().then {
        $0.text = "신청하게 된 계기를 알려주세요"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f3
    }
    
    let answerTwoTV = UITextView().then {
        $0.textColor = .f7
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.f6.cgColor
    }
    
    let answerTwoSubLbl = UILabel().then {
        $0.text = "* 최대 50글자까지 가능합니다"
        $0.font = FontManager.shared.notoSansKR(.regular, 12)
        $0.textColor = .f4
    }
    
    let questionThreeLbl = UILabel().then {
        $0.text = "대화 기간은 매일 7일 동안 이어집니다.\n시작 가능한 날짜를 선택해 주세요."
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f3
    }
    
    let answerThreeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = .clear
        $0.distribution = .equalSpacing
    }
    
    let answerThreeLbl = UILabel().then {
        $0.text = "22년 00월 00일 이후" //format으로 만들기(api대비)
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
        $0.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
    }
    
    let selectDateBtn = UIButton().then {
        $0.setTitle("날짜 선택", for: .normal)
        $0.setTitleColor(.m1, for: .normal)
        $0.titleLabel?.font = FontManager.shared.notoSansKR(.bold, 14)
    }
    
    let datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = .f2
    }
    
    let questionFourLbl = UILabel().then {
        $0.text = "전화를 받을 시간을 선택해 주세요."
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f3
    }
    
    let questionFourSubLbl = UILabel().then {
        $0.text = "(중복 선택 가능)"
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f3
    }
    
    let timeView = TimeView(frame: .zero, timeList: TimeList.timeList)
    let btnView = GLTwoButton(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addComponents()
        setConstraints()
        bind()
        setDoneBtn()
        self.answerTwoTV.delegate = self
    }
    
    func addComponents() {
        view.addSubview(scrollView)
        self.datePicker.isHidden = true
        scrollView.addSubview(contentStackView)

        [answerThreeLbl, selectDateBtn, datePicker].forEach {
            answerThreeStackView.addArrangedSubview($0)
        }
        
        [titleLbl, descriptionLbl, questionOneLbl, emojiTagView, questionTwoLbl, answerTwoTV, answerTwoSubLbl, questionThreeLbl, answerThreeStackView, lineView, questionFourLbl, questionFourSubLbl, timeView, btnView].forEach {
            contentStackView.addArrangedSubview($0)
        }
    }
    
    func setConstraints() {
        scrollView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints{
            $0.edges.equalTo(scrollView).inset(UIEdgeInsets(top: 50, left: Const.padding, bottom: 8, right: Const.padding))
            $0.width.equalTo(scrollView.snp.width).offset(-Const.padding*2)
        }
        
        contentStackView.setCustomSpacing(20, after: titleLbl)
        contentStackView.setCustomSpacing(50, after: descriptionLbl)
        contentStackView.setCustomSpacing(20, after: questionOneLbl)
        contentStackView.setCustomSpacing(50, after: emojiTagView)
        contentStackView.setCustomSpacing(13, after: questionTwoLbl)
        contentStackView.setCustomSpacing(6, after: answerTwoTV)
        contentStackView.setCustomSpacing(50, after: answerTwoSubLbl)
        contentStackView.setCustomSpacing(46, after: lineView)
        contentStackView.setCustomSpacing(20, after: questionFourSubLbl)
        contentStackView.setCustomSpacing(63, after: timeView)
        
        emojiTagView.snp.makeConstraints{
            $0.height.equalTo(100) //TODO: 동적 높이 조절되도록
        }
        
        answerTwoTV.snp.makeConstraints{
            $0.height.equalTo(80)
        }
        
        lineView.snp.makeConstraints{
            $0.height.equalTo(1)
        }
        
        timeView.snp.makeConstraints{
            $0.height.equalTo(180)
        }
        
        btnView.snp.makeConstraints{
            $0.height.equalTo(48)
        }
        
        btnView.okBtn.title = "대화 신청하기"
    }
    
    func bind() {
        selectDateBtn.tapGesture
            .subscribe(onNext: { [weak self] _ in
                self?.datePicker.isHidden = false
            })
            .disposed(by: disposeBag)
        
        btnView.okBtn.tapGesture
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.moveToJoinMatch()
            })
            .disposed(by: disposeBag)
        
        btnView.cancelBtn.tapGesture
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.moveToHome()
            })
            .disposed(by: disposeBag)
    }
    
    //키보드 상단 완료 버튼 추가
    func setDoneBtn() {
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(dismissMyKeyboard))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        self.answerTwoTV.inputAccessoryView = toolbar
    }
    
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
    
    // TextView Delegate
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 50 {
            //TODO: 사용자에게 알림 줘야 하나?
            textView.deleteBackward()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            
        }
    }
}
