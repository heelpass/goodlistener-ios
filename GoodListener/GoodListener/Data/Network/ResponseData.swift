//
//  ResponseData.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/31.
//

import Foundation
import Moya
import SwiftyJSON
import Toaster
import NVActivityIndicatorView

struct ResponseData<Model: Codable> {
    
    static func processModelResponse(_ result: Result<Response, MoyaError>) -> Result<Model?, Error> {
        switch result {
        case .success(let response):
            do {
                Log.d(JSON(response.data))
                // status code가 200...299인 경우만 success로 체크 (아니면 예외발생)
                _ = try response.filterSuccessfulStatusCodes()
                
                let model = try JSONDecoder().decode(Model.self, from: response.data)
                LoadingIndicator.stop()
                return .success(model)
            } catch {
                LoadingIndicator.stop()
                return .failure(error)
            }
        case .failure(let error):
            LoadingIndicator.stop()
            return .failure(error)
        }
    }
    
    static func processJSONResponse(_ result: Result<Response, MoyaError>) -> Result<JSON, Error> {
        switch result {
        case .success(let response):
            do {
                Log.d(JSON(response.data))
                // status code가 200...299인 경우만 success로 체크 (아니면 예외발생)
                _ = try response.filterSuccessfulStatusCodes()
                
                let model = JSON(response.data)
                LoadingIndicator.stop()
                return .success(model)
            } catch {
                LoadingIndicator.stop()
                return .failure(error)
            }
        case .failure(let error):
            LoadingIndicator.stop()
            return .failure(error)
        }
    }
    
    static func makeToast() {
        let toast = Toast(text: "네트워크에 접속할 수 없습니다.\n네트워크 연결 상태를 확인해주세요.")
        toast.view.font = FontManager.shared.notoSansKR(.regular, 13)
        toast.show()
    }
}
