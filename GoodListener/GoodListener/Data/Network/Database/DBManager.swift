//
//  DBManager.swift
//  GoodListener
//
//  Created by cheonsong on 2022/09/07.
//

import Foundation
import RealmSwift

enum PushType: String {
    case call
    case remain5
    case cancel
}

class DBManager {
    static let shared = DBManager()
    
    private init() {}
    
    let realm = try! Realm()
    
    /// DB에 데이터를 추가하는 함수
    ///  - Parameter model: Realm Object를 채택한 모델
    func add(model: Object) {
        try! realm.write {
            realm.add(model)
        }
    }
    
    /// DB에 데이터를 전부 삭제하는 함수
    func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    /// 안읽은 알림 개수 리턴
    func unreadfilter()-> Int {
        let result = realm.objects(PushModel.self)
        
        let filter = result.filter("isRead == false")
        return filter.count
    }
    
    /// 모든 알림 읽기
    func readAllData() {
        let result = realm.objects(PushModel.self)
        let filter = result.filter("isRead == false")
        
        filter.forEach { model in
            try! realm.write {
                model.isRead = true
            }
        }
    }
    
    /// PushData를 저장해주는 함수
    func savePushData() {
        if let userDefault = UserDefaults(suiteName: "group.com.heelpass.good-listener") {
            if let pushData = userDefault.value(forKey: "pushData") as? [String] {
                
                pushData.forEach { pushType in
                    let pushModel = PushModel()
                    
                    // PushModel PK값 지정
                    pushModel.id = UserDefaultsManager.shared.pushCnt + 1
                    UserDefaultsManager.shared.pushCnt = pushModel.id
                    pushModel.date = dateConverter()
                    // PushModel 나머지 value 지정
                    switch pushType {
                    case "call":
                        pushModel.title = "굿리스너 통화 안내"
                        pushModel.body = "[스피커닉네임]님이 통화가 걸었어요~"
                    case "cancel":
                        pushModel.title = "굿리스너 취소 안내"
                        pushModel.body = "[스피커닉네임]님이 통화가 취소됐어요"
                    case "remain5":
                        pushModel.title = "굿리스너 통화 안내"
                        pushModel.body = "5분뒤 [스피커닉네임]과 통화 예정이에요"
                    default:
                        break
                    }
                    
                    // realm DB에 저장
                    add(model: pushModel)
                }

                userDefault.set(nil, forKey: "pushData")
            }
        }
    }
    
    
    private func dateConverter()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: Date())
    }
    
}
