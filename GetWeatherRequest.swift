//
//  GetWeatherRequest.swift
//  TempProject
//
//  Created by Yermek Sabyrzhan on 11/6/20.
//  Copyright © 2020 Yermek Sabyrzhan. All rights reserved.
//

import Foundation
import Alamofire

struct GetWeatherRequest: EndPointType {
    
    let units = "metric"
    let lat: Double
    var lon: Double
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
    
    var query: String {
        let params = [ "lat": lat,
                       "lon": lon,
                       "units": units,
                       "APPID": Constants.AppID ] as [String : Any]
        
        var output: String = ""
        for (key,value) in params {
            output +=  "\(key)=\(value)&"
        }
        output = String(output.dropLast())
        return output
        
    }
    var params: [String : Any]?{
        return nil
    }
    

    var path: String {
        return "data/2.5/weather?"
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
}
