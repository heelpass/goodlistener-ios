//
//  DeleteAccountViewModel.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/30.
//

import Foundation
import RxSwift
import RxCocoa

class DeleteAccountViewModel: ViewModelType {

    var disposeBag: DisposeBag = .init()
    
    struct Input {
        var checkboxSeledted: Observable<Bool>
        var yesBtnTap: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
}
