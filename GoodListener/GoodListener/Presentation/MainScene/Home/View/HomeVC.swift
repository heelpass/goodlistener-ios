//
//  HomeViewController.swift
//  GoodListener
//
//  Created by cheonsong on 2022/07/26.
//

import UIKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView
import SkeletonView

// 신청 전, 매칭 후 2가지 상태
enum homeState {
    case join
    case matched
}

class HomeVC: UIViewController, SnapKitType {

    weak var coordinator: HomeCoordinating?
    let disposeBag = DisposeBag()
    let viewModel = HomeViewModel()

    let navigationView = NavigationView(frame: .zero, type: .notice)
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .m5
    }
    
    var emojiData: BehaviorRelay<[String]> = .init(value: ["check","check","none","check","none","check"])
    
    // 현재 홈 화면 상태
    var homeState: homeState = .join
    
    let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .clear
    }
    
    let titleLbl = UILabel().then {
        $0.text = "당신의 리스너"
        $0.font = FontManager.shared.notoSansKR(.bold, 20)
    }
    
    let containerView = UIView().then {
        $0.layer.cornerRadius = 20
    }

    
    //신청 전 화면 UI 요소
    let joinImg = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "main_img_notalk")
    }
    
    let joinLbl = UILabel().then {
        $0.text = "아직 진행 중인 대화가 없어요.\n지금 바로 대화를 신청해 보세요"
        $0.font = FontManager.shared.notoSansKR(.regular, 16)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = .f4
    }

    let joinBtn = GLButton().then {
        $0.title = "대화 신청하기"
    }
    
    //매칭 후 UI 요소
    let daycheckLbl = UILabel().then{
        let dayformat = "7일 중 %d일차"
        $0.text = String(format: dayformat, 3) //api data
        $0.font = FontManager.shared.notoSansKR(.bold, 20)
        $0.textColor = .m1
        $0.textAlignment = .center
    }
    
    let profileImg = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "person")
        $0.contentMode = .scaleAspectFill
    }
    
    let introLbl = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f4
        $0.lineBreakMode = .byTruncatingTail
    }
        
    let timeLbl = UILabel().then {
        $0.text = "매일 오후 10:20"
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f7
    }
    
    let dateLbl = UILabel().then {
        $0.text = "2022.8.2 ~ 8.8 (7일간)"
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.regular, 14)
        $0.textColor = .f7
    }
    
    lazy var sevendaysRecord = RecordCollectionView(frame: .zero, emojiData: emojiData.value)
    
    let postponeBtn = GLButton().then {
        $0.title = "대화 미루기"
    }
    
    //팝업
    let popup = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.6)
    }
    
    let popupContainer = UIView().then {
        $0.backgroundColor = .m5
        $0.layer .cornerRadius = 10
    }
    
    let popupTitle = UILabel().then {
        $0.text = "오늘은 대화가 힘드신가요?\n리스너에게 미리 알려주세요!"
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
        $0.title = "취소"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .m5
        addComponents()
        setConstraints()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let cnt = DBManager.shared.unreadfilter()
        navigationView.remainNoticeView.isHidden = cnt == 0
        navigationView.remainNoticeLbl.text = "+\(cnt)"
        fetchData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func addComponents() {
        [navigationView, scrollView, joinBtn, postponeBtn].forEach{
            view.addSubview($0)
        }
        scrollView.addSubview(contentStackView)
        [titleLbl, containerView].forEach {
            contentStackView.addArrangedSubview($0)
        }
        [joinImg, joinLbl, daycheckLbl, profileImg, introLbl, timeLbl, dateLbl, sevendaysRecord].forEach {
            containerView.addSubview($0)
        }
        
        containerView.isSkeletonable = true
        navigationView.backgroundColor = .m5
        
        // 팝업
        popup.addSubview(popupContainer)
        [popupTitle, popupBtnStackView].forEach { popupContainer.addSubview($0) }
        [delayBtn, cancelBtn].forEach { popupBtnStackView.addArrangedSubview($0) }
    }
    
    func setConstraints() {
        navigationView.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(35)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView).inset(UIEdgeInsets(top: 35, left: Const.padding, bottom: 100, right: Const.padding))
            $0.width.equalTo(scrollView.snp.width).offset(-Const.padding*2)
        }
        
        contentStackView.setCustomSpacing(20, after: titleLbl)
        
        containerView.snp.makeConstraints {
            $0.height.equalTo(488)
        }
        
        // 신청 전 UI
        joinImg.snp.makeConstraints{
            $0.top.equalToSuperview().offset(80)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }
        joinLbl.snp.makeConstraints{
            $0.top.equalTo(joinImg.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        joinBtn.snp.makeConstraints {
            $0.width.equalTo(Const.glBtnWidth)
            $0.height.equalTo(Const.glBtnHeight)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        self.view.bringSubviewToFront(joinBtn)
        
        
        // 매칭 후 UI
        daycheckLbl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.left.equalToSuperview().offset(70)
            $0.right.equalToSuperview().offset(-70)
        }
        
        profileImg.snp.makeConstraints {
            $0.top.equalTo(daycheckLbl.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 138, height: 138))
            //$0.layer.cornerRadius = self.frame.size.width/2 //일반 사진일 경우
        }
        
        introLbl.snp.makeConstraints{
            $0.top.equalTo(profileImg.snp.bottom).offset(18)
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
        }
        
        
        timeLbl.snp.makeConstraints{
            $0.top.equalTo(introLbl.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        dateLbl.snp.makeConstraints{
            $0.top.equalTo(timeLbl.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        sevendaysRecord.snp.makeConstraints{
            $0.top.equalTo(dateLbl.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(28)
            $0.right.equalToSuperview().offset(-28)
            $0.bottom.equalToSuperview().offset(-26)
            
        }
        
        postponeBtn.snp.makeConstraints {
            $0.width.equalTo(Const.glBtnWidth)
            $0.height.equalTo(Const.glBtnHeight)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        self.view.bringSubviewToFront(postponeBtn)

        
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
        self.view.addSubview(self.popup)
        self.popup.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func bind() {
        let output = viewModel.transform(input: HomeViewModel.Input(naviRightBtnTap: navigationView.rightBtn.rx.tap.asObservable(),
                                                                    joinBtnTap: joinBtn.rx.tap.asObservable(),
                                                                    postponeBtnTap: postponeBtn.rx.tap.asObservable(),
                                                                    delayBtnTap: delayBtn.rx.tap.asObservable()))
        
        //네비게이션 오른쪽 버튼
        output.naviRightBtnResult
            .emit(with: self, onNext: { strongself, _ in
                strongself.coordinator?.moveToNotice()
            })
            .disposed(by: disposeBag)
    
        //신청하기 화면 이동
        output.joinBtnResult
            .emit(with: self, onNext: { strongself, _ in
                strongself.coordinator?.join()
            })
            .disposed(by: disposeBag)
        
        //오늘 대화 미루기
        output.postponeBtnResult
            .emit(with: self, onNext: { strongself, _ in
                strongself.popup.isHidden = false
            })
            .disposed(by: disposeBag)
                        
        //대화 1회 미루기
        output.delayBtnResult
            .emit(with: self, onNext: { strongself, _ in
                strongself.popup.isHidden = true
                strongself.postponeBtn.isEnabled = false
                strongself.postponeBtn.backgroundColor = UIColor(hex: "#999999")
            })
            .disposed(by: disposeBag)

        //취소
        cancelBtn.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else {return}
                self.popup.isHidden = true
            })
            .disposed(by: disposeBag)
    
    }
    
    func changeUI(_ type: homeState) {
        switch type {
        case .join:
            joinImg.isSkeletonable = true
            joinLbl.isSkeletonable = true
            joinBtn.isSkeletonable = true
            
            joinImg.isHidden = false
            joinLbl.isHidden = false
            joinBtn.isHidden = false
            
            joinImg.showAnimatedGradientSkeleton()
            joinLbl.showAnimatedGradientSkeleton()
            joinBtn.showAnimatedGradientSkeleton()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.joinImg.hideSkeleton()
                self.joinLbl.hideSkeleton()
                self.joinBtn.hideSkeleton()
            }
            break
        case .matched:
            
            daycheckLbl.isSkeletonable = true
            profileImg.isSkeletonable = true
            introLbl.isSkeletonable = true
            timeLbl.isSkeletonable = true
            dateLbl.isSkeletonable = true
            sevendaysRecord.isSkeletonable = true
            postponeBtn.isSkeletonable = true
            
            daycheckLbl.isHidden = false
            profileImg.isHidden = false
            introLbl.isHidden = false
            timeLbl.isHidden = false
            dateLbl.isHidden = false
            sevendaysRecord.isHidden = false
            postponeBtn.isHidden = false
            
            daycheckLbl.showAnimatedGradientSkeleton()
            profileImg.showAnimatedGradientSkeleton()
            introLbl.showAnimatedGradientSkeleton()
            timeLbl.showAnimatedGradientSkeleton()
            dateLbl.showAnimatedGradientSkeleton()
            sevendaysRecord.showAnimatedGradientSkeleton()//TODO: 나중에 API 수정되면 속도 확인
            postponeBtn.showAnimatedGradientSkeleton()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.daycheckLbl.hideSkeleton()
                self.profileImg.hideSkeleton()
                self.introLbl.hideSkeleton()
                self.timeLbl.hideSkeleton()
                self.dateLbl.hideSkeleton()
                self.sevendaysRecord.hideSkeleton()
                self.postponeBtn.hideSkeleton()
                
                self.introLbl.textColorAndFontChange(text: self.introLbl.text!, color: .f2, font: FontManager.shared.notoSansKR(.bold, 14), range: [UserDefaultsManager.shared.listenerName])
            }

            containerView.backgroundColor = .white
            containerView.layer.borderColor = UIColor(hex: "#B1B3B5").cgColor
            containerView.layer.applySketchShadow(color: UIColor(hex: "#B1B3B5"), alpha: 0.7, x: 0, y: 0, blur: 15, spread: 0)
            
            break
        }
    }
    
    func initUI() {
        joinImg.isHidden = true
        joinLbl.isHidden = true
        joinBtn.isHidden = true
        daycheckLbl.isHidden = true
        profileImg.isHidden = true
        introLbl.isHidden = true
        timeLbl.isHidden = true
        dateLbl.isHidden = true
        sevendaysRecord.isHidden = true
        joinBtn.isHidden = true
        postponeBtn.isHidden = true
        popup.isHidden = true
        containerView.layer.borderColor = .none
    }
    
    
    func fetchData(){
        initUI()
        self.containerView.showAnimatedGradientSkeleton()
        
        MatchAPI.MatchedListener { model, failed in
            self.containerView.hideSkeleton()
            if let model = model {
                UserDefaultsManager.shared.listenerName = model.nickname
                UserDefaultsManager.shared.listenerGender = model.listener.gender.localized
                UserDefaultsManager.shared.listenerAge = model.listener.ageRange.localized
                UserDefaultsManager.shared.listenerJob = model.listener.job.localized
                UserDefaultsManager.shared.listenerDescription = model.listener.description
                UserDefaultsManager.shared.channel = model.channel
                UserDefaultsManager.shared.schedule = model.meetingTime
                UserDefaultsManager.shared.meetingTime = self.formattedTime(model.meetingTime)
                UserDefaultsManager.shared.meetingDate = self.formattedDate(model.meetingTime)
                UserDefaultsManager.shared.listenerId = model.listener.id
                UserDefaultsManager.shared.speakerId = model.speakerId
                UserDefaultsManager.shared.channelId = model.channelId
                UserDefaultsManager.shared.listenerProfileImage = model.listener.profileImg
                
                self.homeState = .matched
                self.introLbl.text = "안녕하세요?\n저는 "+UserDefaultsManager.shared.listenerName+"에요"
                self.timeLbl.text = UserDefaultsManager.shared.meetingTime
                self.dateLbl.text = UserDefaultsManager.shared.meetingDate
                self.changeUI(self.homeState)
            } else {
                self.homeState = .join
                self.changeUI(self.homeState)
            }
        }
    }
    
    func formattedTime(_ time: String) -> String {
        let endIdx = time.count - 1
        var emptyString = ""
        for num in 11 ... endIdx {
            emptyString += String(time[time.index(time.startIndex, offsetBy: num)])
        }
        return "매일 " + emptyString.localized
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
