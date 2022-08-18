//
//  UserInfoViewModel.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/17.
//

import Foundation
import RxSwift
import RxCocoa

class PersonalInfoViewModel: ViewModelType {
    var disposeBag: DisposeBag = .init()
    var model = Model()
    
    struct Model {
        var gender = BehaviorRelay<String>(value: "")
        var age    = BehaviorRelay<String>(value: "")
        var job    = BehaviorRelay<String>(value: "")
    }
    
    struct Input {
        var genderTag: BehaviorRelay<String>
        var ageTag: BehaviorRelay<String>
        var jobTag: BehaviorRelay<String>
    }
    
    struct Output {
        var canNext: Signal<Bool>
    }
    
    func transform(input: Input) -> Output {
        let canNext = BehaviorRelay<Bool>(value: false)
        
        input.genderTag
            .bind(to: model.gender)
            .disposed(by: disposeBag)
        
        input.ageTag
            .bind(to: model.age)
            .disposed(by: disposeBag)
        
        input.jobTag
            .bind(to: model.job)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(model.gender, model.age, model.job)
            .subscribe(onNext: { (gender, age, job) in
                if gender.isEmpty || age.isEmpty || job.isEmpty {
                    canNext.accept(false)
                } else {
                    canNext.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        
        return Output(canNext: canNext.asSignal(onErrorJustReturn: false))
    }
    
}
