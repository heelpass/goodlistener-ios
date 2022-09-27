//
//  Codable+.swift
//  GoodListener
//
//  Created by cheonsong on 2022/09/27.
//

import Foundation

extension Encodable {
    
    // Object -> Dictionary
    public var toDictionary : [String: Any]? {
        guard let object = try? JSONEncoder().encode(self) else { return nil }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String:Any] else { return nil }
        return dictionary
    }
}
