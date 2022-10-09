//
//  JoinMatchVC.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/08/24.
//

import UIKit
import RxSwift

enum JoinMatchState {
    case waiting
    case unable
    case matched
}

class JoinMatchVC: UIViewController, SnapKitType {
    
    weak var coordinator: JoinCoordinating?
    let disposeBag = DisposeBag()
    
    // 현재 매칭 화면 상태
    var joinMatchState: JoinMatchState = .matched
    
    //MARK: - 대기 중 State
    let waitingLbl = UILabel().then{
        $0.text = "잠시만 기다려 주세요..."
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.bold, 20)
        $0.textColor = .f2
    }
    
    let waitingImg = UIImageView().then{
        $0.image = #imageLiteral(resourceName: "main_img_matching")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let waitingdescriptionLbl = UILabel().then{
        $0.text = "대화가 가능한 리스너를\n 찾고 있어요!"
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
        $0.textColor = .f4
    }
    
    //MARK: - 매칭 불가 State
    let unableLbl = UILabel().then {
        $0.text = "죄송합니다"
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.bold, 20)
        $0.textColor = .f2
    }
    
    let unableSubLbl = UILabel().then {
        $0.text = "해당 시간에는 대화 가능한\n리스너가 없어요..."
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.bold, 20)
        $0.textColor = .f2
    }
    
    let unableImg = UIImageView().then{
        $0.image = #imageLiteral(resourceName: "main_img_impossible")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let unabledescriptionLbl = UILabel().then {
        $0.text = "다른 시간으로 리스너에게\n대화를 신청해 볼까요?"
        $0.numberOfLines = 0
        $0.sizeToFit()
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
        $0.textColor = .f4
    }
    
    //MARK: - 매칭 완료 State
    let matchedTitle = UILabel().then {
        $0.text = "새로운 리스너가 매칭되었어요!"
        $0.font = FontManager.shared.notoSansKR(.bold, 20)
        $0.textAlignment = .center
        $0.textColor = .f2
    }
    
    let matchedListenerLbl = UILabel().then{
        $0.text = "리스너"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f3
    }

    let matchedImg = UIImageView().then{
        $0.image = #imageLiteral(resourceName: "person")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let matchedNameLbl = UILabel().then {
        $0.text = "명랑한 지윤지"
        $0.font = FontManager.shared.notoSansKR(.bold, 18)
        $0.textColor = .f3
    }
    
    let matchedListenerStackView = UIStackView().then{
        $0.axis = .horizontal
        $0.backgroundColor = .clear
    }
    
    let matchedGenderLbl = UILabel().then {
        $0.text = "여성"
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f2
    }
    
    let lineOneView = UIView().then {
        $0.backgroundColor = .f6
    }
    
    let matchedAgeLbl = UILabel().then {
        $0.text = "20대"
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f2
    }
    
    let lineTwoView = UIView().then{
        $0.backgroundColor = .f6
    }
    
    let matchedjobLbl = UILabel().then{
        $0.text = "프리랜서"
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f2
    }
    
    let matchedIntroLbl = UILabel().then{
        $0.text = "한마디"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f3
    }
    
    let matchedIntrolDescriptionLbl = UILabel().then {
        $0.text = "안녕하세요안녕하세요"
        $0.textAlignment = .left
        $0.numberOfLines = 3
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f4
        $0.lineBreakMode = .byTruncatingTail
    }
    
    let matchedScheduleLbl = UILabel().then {
        $0.text = "대화 시간"
        $0.font = FontManager.shared.notoSansKR(.bold, 16)
        $0.textColor = .f3
    }
    
    let matchedTimeLbl = UILabel().then{
        $0.text = "meetingTime"
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f4
    }
    
    let matchedDateLbl = UILabel().then {
        $0.text = "meetingDate" //TODO: 편집 필요
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f4
    }
  
    let confirmBtn = GLButton().then {
        $0.title = "확인"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .m5
        addComponents()
        setConstraints()
        bind()
        
        self.changeUI(JoinMatchState.waiting)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.fetchData()
        }
    }
    
    func addComponents() {
        [waitingLbl, waitingImg, waitingdescriptionLbl, unableLbl, unableSubLbl, unableImg, unabledescriptionLbl, matchedTitle, matchedListenerLbl, matchedImg, matchedNameLbl, matchedListenerStackView, matchedIntroLbl, matchedIntrolDescriptionLbl, matchedScheduleLbl, matchedTimeLbl, matchedDateLbl, confirmBtn].forEach {
            view.addSubview($0)
        }
        
        [matchedGenderLbl, lineOneView, matchedAgeLbl, lineTwoView, matchedjobLbl]
            .forEach{
                matchedListenerStackView.addArrangedSubview($0)
            }
    }
    
    func setConstraints() {
        waitingLbl.snp.makeConstraints{
            $0.top.equalToSuperview().offset(200)
            $0.centerX.equalToSuperview()
        }
        
        waitingImg.snp.makeConstraints {
            $0.top.equalTo(waitingLbl.snp.bottom).offset(33)
            $0.centerX.equalToSuperview()
        }
        
        waitingdescriptionLbl.snp.makeConstraints{
            $0.top.equalTo(waitingImg.snp.bottom).offset(29)
            $0.centerX.equalToSuperview()
        }
        
        unableLbl.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(128)
            $0.centerX.equalToSuperview()
        }
        
        unableSubLbl.snp.makeConstraints{
            $0.top.equalTo(unableLbl.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        unableImg.snp.makeConstraints {
            $0.top.equalTo(unableSubLbl.snp.bottom).offset(33)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        unabledescriptionLbl.snp.makeConstraints {
            $0.top.equalTo(unableImg.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        matchedTitle.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(35)
            $0.centerX.equalToSuperview()
        }
        
        matchedListenerLbl.snp.makeConstraints{
            $0.top.equalTo(matchedTitle.snp.bottom).offset(35)
            $0.left.equalToSuperview().offset(44)
        }
        
        matchedImg.snp.makeConstraints{
            $0.top.equalTo(matchedListenerLbl.snp.bottom).offset(17)
            $0.left.equalToSuperview().offset(44)
            $0.size.equalTo(72)
        }
        
        matchedNameLbl.snp.makeConstraints{
            $0.top.equalTo(matchedListenerLbl.snp.bottom).offset(26)
            $0.left.equalTo(matchedImg.snp.right).offset(12)
        }
        
        matchedListenerStackView.snp.makeConstraints{
            $0.top.equalTo(matchedNameLbl.snp.bottom).offset(8)
            $0.left.equalTo(matchedImg.snp.right).offset(12)
        }
        
        matchedListenerStackView.spacing = 5
        
        lineOneView.snp.makeConstraints{
            $0.size.equalTo(CGSize(width: 2, height: 15))
        }
        
        lineTwoView.snp.makeConstraints{
            $0.size.equalTo(CGSize(width: 2, height: 15))
        }
        
        matchedIntroLbl.snp.makeConstraints{
            $0.top.equalTo(matchedImg.snp.bottom).offset(45)
            $0.left.equalToSuperview().offset(44)
        }
        
        matchedIntrolDescriptionLbl.snp.makeConstraints{
            $0.top.equalTo(matchedIntroLbl.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(44)
            $0.right.equalToSuperview().offset(-44)
        }
        
        matchedScheduleLbl.snp.makeConstraints{
            $0.top.equalTo(matchedIntrolDescriptionLbl.snp.bottom).offset(44)
            $0.left.equalToSuperview().offset(44)
        }
        
        matchedTimeLbl.snp.makeConstraints{
            $0.top.equalTo(matchedScheduleLbl.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(44)
        }
        
        matchedDateLbl.snp.makeConstraints{
            $0.top.equalTo(matchedTimeLbl.snp.bottom)
            $0.left.equalToSuperview().offset(44)
        }
        
        confirmBtn.snp.makeConstraints {
            $0.width.equalTo(Const.glBtnWidth)
            $0.height.equalTo(Const.glBtnHeight)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
    }
    
    func bind() {
        confirmBtn.rx.tap
            .bind(onNext: { [weak self] in
                self?.coordinator?.moveToHome()
            })
            .disposed(by: disposeBag)
    }
    
    func changeUI(_ type: JoinMatchState) {
        switch type {
        case  .waiting:
            waitingLbl.isHidden = false
            waitingImg.isHidden = false
            waitingdescriptionLbl.isHidden = false
            unableLbl.isHidden = true
            unableSubLbl.isHidden = true
            unableImg.isHidden = true
            unabledescriptionLbl.isHidden = true
            matchedTitle.isHidden = true
            matchedListenerLbl.isHidden = true
            matchedImg.isHidden = true
            matchedNameLbl.isHidden = true
            matchedListenerStackView.isHidden = true
            matchedIntroLbl.isHidden = true
            matchedIntrolDescriptionLbl.isHidden = true
            matchedScheduleLbl.isHidden = true
            matchedTimeLbl.isHidden = true
            matchedDateLbl.isHidden = true
            confirmBtn.isHidden = true
            break
        case .unable:
            waitingLbl.isHidden = true
            waitingImg.isHidden = true
            waitingdescriptionLbl.isHidden = true
            unableLbl.isHidden = false
            unableSubLbl.isHidden = false
            unableImg.isHidden = false
            unabledescriptionLbl.isHidden = false
            matchedTitle.isHidden = true
            matchedListenerLbl.isHidden = true
            matchedImg.isHidden = true
            matchedNameLbl.isHidden = true
            matchedListenerStackView.isHidden = true
            matchedIntroLbl.isHidden = true
            matchedIntrolDescriptionLbl.isHidden = true
            matchedScheduleLbl.isHidden = true
            matchedTimeLbl.isHidden = true
            matchedDateLbl.isHidden = true
            confirmBtn.isHidden = false
            break
        case .matched:
            waitingLbl.isHidden = true
            waitingImg.isHidden = true
            waitingdescriptionLbl.isHidden = true
            unableLbl.isHidden = true
            unableSubLbl.isHidden = true
            unableImg.isHidden = true
            unabledescriptionLbl.isHidden = true
            matchedTitle.isHidden = false
            matchedListenerLbl.isHidden = false
            matchedImg.isHidden = false
            matchedNameLbl.isHidden = false
            matchedListenerStackView.isHidden = false
            matchedIntroLbl.isHidden = false
            matchedIntrolDescriptionLbl.isHidden = false
            matchedScheduleLbl.isHidden = false
            matchedTimeLbl.isHidden = false
            matchedDateLbl.isHidden = false
            confirmBtn.isHidden = false
            break
        }
    }
    
    func fetchData() {
        MatchAPI.MatchedListener { succeed, failed in
            if (succeed != nil) {
                guard let model = succeed else {return}
                UserDefaultsManager.shared.listenerName = model.nickname
                UserDefaultsManager.shared.listenerGender = model.listener.gender.localized
                UserDefaultsManager.shared.listenerAge = model.listener.ageRange.localized
                UserDefaultsManager.shared.listenerJob = model.listener.job.localized
                UserDefaultsManager.shared.listenerDescription = model.listener.description
                UserDefaultsManager.shared.meetingTime = model.meetingTime
                
                self.matchedNameLbl.text = UserDefaultsManager.shared.listenerName
                self.matchedGenderLbl.text = UserDefaultsManager.shared.listenerGender
                self.matchedAgeLbl.text = UserDefaultsManager.shared.listenerAge
                self.matchedjobLbl.text = UserDefaultsManager.shared.listenerJob
                self.matchedIntrolDescriptionLbl.text = UserDefaultsManager.shared.listenerDescription
                self.matchedTimeLbl.text = self.formattedTime(UserDefaultsManager.shared.meetingTime)
                self.matchedDateLbl.text = self.formattedDate(UserDefaultsManager.shared.meetingTime)

                self.changeUI(.matched)
            } else {
                self.changeUI(.waiting)
            }
        }
    }
    
    func formattedTime(_ time: String) -> String {
        let endIdx = time.count - 1
        var emptyString = ""
        for num in 11 ... endIdx {
            emptyString += String(time[time.index(time.startIndex, offsetBy: num)])
        }
        return emptyString.localized
    }
    
    func formattedDate(_ date: String) -> String {
        let periodFormat = "%@ ~ %@ (7일간)"
        
        //시작 날짜 구하기
        let startdateFormat = "%@.%@.%@"
        var startDate = "" //시작일
        var startyear = "" //시작 년도
        var startMon = "" //시작 월
        var startDay = "" //시작 일
        
        for yearIdx in 0 ... 3 {
            startyear += String(date[date.index(date.startIndex, offsetBy: yearIdx)])
        }
        
        let fifthIdx = date.index(date.startIndex, offsetBy: 5)
        let sixthIdx = date.index(date.startIndex, offsetBy: 6)
        let eightIdx = date.index(date.startIndex, offsetBy: 8)
        let ninthIdx = date.index(date.startIndex, offsetBy: 9)
        
        
        if (String(date[fifthIdx]) == "1") {
            startMon = "\(date[fifthIdx])" + "\(date[sixthIdx])"
        } else {
            startMon = "\(date[sixthIdx])"
        }
        
        if (String(date[eightIdx]) == "1" || String(date[eightIdx]) == "2" || String(date[eightIdx]) == "3" ){
            startDay = "\(date[eightIdx])" + "\(date[ninthIdx])"
        } else {
            startDay = "\(date[ninthIdx])"
        }
        
        startDate = String(format: startdateFormat, startyear, startMon, startDay)
        
        
        // 끝나는 날짜 구하기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        var sevendays = DateComponents()
        sevendays.day = 7
        
        var endDate = "" //끝나는 날
    
        if let calculate = Calendar.current.date(byAdding: sevendays, to: self.getStringToDate(strDate: String(format: startdateFormat, startyear, startMon, startDay), format: "yyyy.MM.dd")){
            endDate = dateFormatter.string(from: calculate)
        }

        return String(format: periodFormat, startDate, endDate)
    }
    
    // String ➡️ Date
    func getStringToDate(strDate: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
        return dateFormatter.date(from: strDate)!
    }
}
