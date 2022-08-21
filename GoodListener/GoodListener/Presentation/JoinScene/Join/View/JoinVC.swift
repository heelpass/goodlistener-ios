//
//  JoinVC.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/08/21.
//

import UIKit
import RxSwift

class JoinVC: UIViewController, SnapKitType {


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
    
    let questionOneStackView = UIStackView().then{
        $0.axis = .horizontal
        $0.backgroundColor = .clear
    }
    
    let questionOneLbl = UILabel().then {
        $0.text = "저는 이런 대화를 원해요"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f3
    }
    
    let questionOneSubLbl = UILabel().then {
        $0.text = "(중복 선택 가능)"
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f3
    }
    
    // TODO: 이모지 버튼 추가
    let questionTwoLbl = UILabel().then {
        $0.text = "신청하게 된 계기를 알려주세요"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f3
    }
    
    // TODO: 텍스트 필드 추가
    let questionThreeLbl = UILabel().then {
        $0.text = "대화 기간은 매일 7일 동안 이어집니다.\n시작 가능한 날짜를 선택해 주세요."
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f3
    }
    
    let answerFourStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = .clear
        $0.distribution = .equalCentering
    }
    
    let answerFourLbl = UILabel().then {
        $0.text = "22년 00월 00일 이후" //format으로 만들기(api대비)
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
        $0.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
    }
    
    let selectDateBtn = UIButton().then {
        $0.setTitle("날짜 선택", for: .normal)
        $0.setTitleColor(.m1, for: .normal)
        $0.titleLabel?.font = FontManager.shared.notoSansKR(.bold, 14)
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
    
    //TODO: 날짜 시간 뷰 추가
    //TODO: 버튼 2개 공용 뷰 추가
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addComponents()
        setConstraints()
    }
    
    func addComponents() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        [questionOneLbl, questionOneSubLbl].forEach {
            questionOneStackView.addArrangedSubview($0)
        }
        
        [answerFourLbl, selectDateBtn].forEach {
            answerFourStackView.addArrangedSubview($0)
        }
        
        [titleLbl, descriptionLbl, questionOneStackView, questionTwoLbl, questionThreeLbl, answerFourStackView, lineView, questionFourLbl, questionFourSubLbl].forEach {
            contentStackView.addArrangedSubview($0)
        }
    }
    
    func setConstraints() {
        scrollView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints{
            $0.edges.equalTo(scrollView).inset(UIEdgeInsets(top: 50, left: Const.padding, bottom: 0, right: Const.padding))
            $0.width.equalTo(scrollView.snp.width).offset(-Const.padding*2)
        }
        
        contentStackView.setCustomSpacing(20, after: titleLbl)
        contentStackView.setCustomSpacing(50, after: descriptionLbl)
        
        lineView.snp.makeConstraints{
            $0.height.equalTo(1)
        }

    }
}
