//
//  RecordViewController.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/07/26.
//

import UIKit
import RxSwift

enum recordState{
    case nothing
    case progress
}

class RecordVC: UIViewController, SnapKitType{
    weak var coordinator: RecordCoordinating?
    var recordState: recordState = .nothing
    
    let navigationView = NavigationView(frame: .zero, type: .notice)
    
    let titleLbl = UILabel().then {
        $0.text = "나의 대화 기록"
        $0.textColor = .f2
        $0.font = FontManager.shared.notoSansKR(.bold, 18)
    }
    
    //진행 중인 대화가 없을 때
    let nothingImg = UIImageView().then{
        $0.image = #imageLiteral(resourceName: "main_img_notalk")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
       // $0.frame = CGRect(origin: .zero, size: CGSize(width: 500, height: 500))
    }
    
    let nothingLbl = UILabel().then {
        $0.text = "아직 진행 중인 대화가 없어요"
        $0.textAlignment = .center
        $0.font = FontManager.shared.notoSansKR(.regular, 15)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .m5
        addComponents()
        setConstraints()
        changeUI(recordState)
    }
    
    
    func addComponents() {
        [navigationView, titleLbl, nothingImg, nothingLbl].forEach{
            view.addSubview($0)
        }
        navigationView.backgroundColor = .m5
    }
    
    func setConstraints() {
        navigationView.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(35)
        }
        
        titleLbl.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom).offset(35)
            $0.left.equalToSuperview().offset(30)
        }
        
        nothingImg.snp.makeConstraints{
            $0.top.equalTo(titleLbl.snp.bottom).offset(115)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        nothingLbl.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nothingImg.snp.bottom).offset(32)
        }
    }
    
    func changeUI(_ type: recordState) {
        switch type{
        case .nothing:
            nothingImg.isHidden = false
            nothingLbl.isHidden = false
            break
        case .progress:
            break
        }
    }
    
}
