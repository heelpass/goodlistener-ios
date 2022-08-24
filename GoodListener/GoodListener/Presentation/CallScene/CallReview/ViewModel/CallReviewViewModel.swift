//
//  CallReviewViewModel.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/23.
//

import Foundation
import RxSwift
import RxCocoa

class CallReviewViewModel: ViewModelType {
    
    var disposeBag: DisposeBag = .init()
    
    struct Input {
        let reviewText: Observable<String> // 입력된 리뷰
        let moodTag: BehaviorRelay<String> // 선택된 무드 태그
        let sendReview: Observable<Void> // 리뷰 보내기 (당일 확인, 일주일 재신청,다음에하기 동일하게 작동하는지 기획에 물어봐야함)
    }
    
    struct Output {
        let textValidationResult: Signal<String> // 텍스트 50자 제한 검증 여부
        let sendReviewResult: Signal<Bool> // 리뷰 보내기 결과 (API)
    }
    
    func transform(input: Input) -> Output {
        let textValidationResult = PublishRelay<String>()
        let sendReviewResult = PublishRelay<Bool>()
        
        input.reviewText
            .bind(onNext: { [weak self] (text) in
                guard let self = self else { return }
                var result = text
                if !self.validateReview(text) {
                    result = String(result.removeLast())
                }
                textValidationResult.accept(result)
            })
            .disposed(by: disposeBag)
        
        input.sendReview
            .withLatestFrom(Observable.combineLatest(input.reviewText, input.moodTag))
            .bind(onNext: { [weak self] (text, mood) in
                guard let self = self else { return }
                // API 콜 후 응답결과를 출력
                sendReviewResult.accept(self.sendReview(text.trimmingCharacters(in: .whitespacesAndNewlines), mood))
            })
            .disposed(by: disposeBag)
        
        return Output(textValidationResult: textValidationResult.asSignal(onErrorJustReturn: ""),
                      sendReviewResult: sendReviewResult.asSignal(onErrorJustReturn: false))
    }
    
    // 문자열 검증 함수
    private func validateReview(_ text: String)-> Bool {
        //TODO: 백엔드에 텍스트에 이모티콘 들어가도 되는지 물어보고 수정 필요
        return text.count <= 50
    }
    
    // 리뷰보내기 함수
    //TODO: 리뷰 보내기 API 작업되면 구현 필요
    private func sendReview(_ text: String, _ mood: String)-> Bool {
        Log.d("text::\(text), mood::\(mood)")
        return true
    }
}
