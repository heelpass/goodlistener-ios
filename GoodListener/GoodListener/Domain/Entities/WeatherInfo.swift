//
//  WeatherInfo.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/07/31.
//

import Foundation

struct WeatherInfo: Codable {
    var coord: Location
    var name: String?
    
    var message: String?
    var type: String?
    var reason: String?
    var payload: ErrorPayLoadCodable?
}

struct Location: Codable {
    var lat: Float?
    var lon: Float?
}
