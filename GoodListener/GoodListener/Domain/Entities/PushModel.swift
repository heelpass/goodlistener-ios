//
//  PushModel.swift
//  GoodListener
//
//  Created by cheonsong on 2022/09/07.
//

import Foundation
import RealmSwift

class PushModel: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var body: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var isRead: Bool = false
    
    // PK 지정
    override static func primaryKey() -> String? {
        return "id"
    }
}
