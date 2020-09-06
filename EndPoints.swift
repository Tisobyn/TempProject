//
//  EndPoints.swift
//  TempProject
//
//  Created by Yermek Sabyrzhan on 11/6/20.
//  Copyright © 2020 Yermek Sabyrzhan. All rights reserved.
//

import Foundation
import Alamofire

protocol EndPointType {
    
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
    var query: String { get }
    var params: [String: Any]? { get }
}
extension EndPointType {
    
    var baseURL: String {
        return "http://api.openweathermap.org/"
    }
    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json"]
    }
    
    var url: URL {
        return URL(string: self.baseURL + self.path + self.query)!
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
}
