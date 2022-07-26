//
//  ViewModelType.swift
//  GoodListener
//
//  Created by cheonsong on 2022/07/25.
//

import Foundation
import RxSwift

/**
 뷰모델 클래스를 작성시 해당 프로토콜을 채택해주세요
 */
protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag {get set}
    
    func transform(input: Input)-> Output
}
