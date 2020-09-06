//
//  APIManager.swift
//  TempProject
//
//  Created by Yermek Sabyrzhan on 11/6/20.
//  Copyright © 2020 Yermek Sabyrzhan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias ResultHandler<T> = (ResultResponse<T>) -> Void

enum ResultResponse<Value> {
    case success(Value)
    case failure(ResponseError?)
}

struct ResponseError {
    let errorCode: Int
    let errorMessage: String
}

class APIManager {
    // MARK: - Vars & Lets
    private static var sharedApiManager: APIManager = {
        let apiManager = APIManager()
        
        return apiManager
    }()
    
    // MARK: - Accessors
    class func shared() -> APIManager {
        return sharedApiManager
    }
    
    //MARK: - Gateway
    func request<T>(type: EndPointType, handler: @escaping ResultHandler<T>) where T: Codable {
        
        AF.request(type.url, method: type.httpMethod , parameters: type.params, encoding: type.encoding, headers: type.headers).validate().responseJSON { [weak self] (response) in
            guard let _ = self else {
                return
            }
//            print("APIManager.request.AF.type.url =\(type.url)")
            switch response.result {
            case let .success(value):
//                    print("APIManager.request.AF.success =\(value)")
                    let decoder = JSONDecoder()
//                    print("APIManager.request.AF.success.decoder =\(decoder)")
                    if let data = response.data {
//                        print("APIManager.request.AF.success.data =\(data)")
                        if let jsonResult = try? decoder.decode(T.self, from: data) {
                            handler(.success(jsonResult))
                            print("APIManager.request.AF.success.data.jsonResult =\(jsonResult)")
                        }else{
                            let error = ResponseError(errorCode: 999, errorMessage: FailureError.jsonEncodingFailed.rawValue)
                            print("APIManager.request.AF.success.data.error =\(error)")
                            handler(.failure(error))
                        }
                    }else{
                        let error = ResponseError(errorCode: 999, errorMessage: FailureError.emptyData.rawValue)
//                        print("APIManager.request.AF.success.elseerror =\(error)")
                        handler(.failure(error))
                    }

            case .failure(_):
                    let error = ResponseError(errorCode: response.response?.statusCode ?? 999, errorMessage: response.error?.localizedDescription ?? "")
                    handler(.failure(error))
            }
        }
    }
}
