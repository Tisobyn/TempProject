//
//  ErrorHandler.swift
//  TempProject
//
//  Created by Yermek Sabyrzhan on 11/6/20.
//  Copyright © 2020 Yermek Sabyrzhan. All rights reserved.
//

import Foundation


enum ErrorHandler :Error {
    case offline
    case invalidData
    case requestFailed
    case jsonParsinFail
    case responseUnsuccessful
    case noLocation
    case error(error:String)
    
    
    
    var localizedDescription: String{
        switch self {
            case .offline:
                return "Disconnected to the internet."
            case .invalidData:
                return "Invalid data."
            case .requestFailed:
                return "Request failed."
            case .jsonParsinFail:
                return "Json parse fail"
            case .responseUnsuccessful:
                return "Response unsuccessful."
            case .error(let error):
                return "\(error)."
            case .noLocation:
                return "Cannot detect the location."
        }
    }
}
