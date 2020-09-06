//
//  WeatherViewModel.swift
//  TempProject
//
//  Created by Yermek Sabyrzhan on 11/6/20.
//  Copyright © 2020 Yermek Sabyrzhan. All rights reserved.
//
import Foundation

class WeatherViewModel {
    
    var weather: WeatherResponce? = nil
    var onDataDidChange: (() -> Void)? = nil

    //MARK: API
    func getWeatherData(lat: Double, lon: Double){
        let request = GetWeatherRequest(lat: lat, lon: lon)
        APIManager.shared().request(type: request) { [weak self] (result: ResultResponse<WeatherResponce>)  in
            switch result{
            case .success(let data):
                self?.weather = data
//                self?.onDataDidChange?()
                UserDefaults.standard.set(lat, forKey: "lat")
                UserDefaults.standard.set(lon, forKey: "lon")
//                print("WeatherViewModel.getWeatherData.success.weather =\(self?.weather)")
                
            case .failure(let error):
                print(error?.errorMessage ?? "Error fetching data")

            }
        }
    }

}
