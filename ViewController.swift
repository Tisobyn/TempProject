//
//  ViewController.swift
//  TempProject
//
//  Created by Yermek Sabyrzhan on 11/6/20.
//  Copyright © 2020 Yermek Sabyrzhan. All rights reserved.
//

import UIKit
import GooglePlaces
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation
import Foundation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    lazy var locationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Location"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    lazy var dayLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Sunday"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    lazy var conditionLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Sunny"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    lazy var tempLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 80)
        label.text = "00"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    lazy var degreeLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "℃"
        label.textAlignment = .center
        label.textColor = .white
        label.frame.size.height = 25
        label.frame.size.width = 25
        return label
    }()
    lazy var conditionImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "01d")
        img.contentMode = .scaleAspectFit
        return img
    }()
    lazy var  backgroundView : UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .blue
        return view
    }()
    var activityIndicator : NVActivityIndicatorView!
    let gradientLayer = CAGradientLayer()
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var lat = UserDefaults.standard.double(forKey: "lat") 
    var lon = UserDefaults.standard.double(forKey: "lon") 
    var locationManager = CLLocationManager()
    let weatherViewModel: WeatherViewModel = WeatherViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        definesPresentationContext = true
        searchController?.hidesNavigationBarDuringPresentation = false
        
        addSubviews()
        setupConstraints()
        backgroundView.layer.addSublayer(gradientLayer)
        locationManager.requestWhenInUseAuthorization()
        
        self.view.addSubview(activityIndicator)
        activityIndicator.stopAnimating()
        
//        if(CLLocationManager.locationServicesEnabled()){
//            activityIndicator.startAnimating()
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.startUpdatingLocation()
//            //потом на coordinate.lat i lon поменять
//            updateWeather(latitude: lat , longitude: lon)
//
//        }
//        else {
//            updateWeather(latitude: lat , longitude: lon)
//        }
        updateWeather(latitude: lat , longitude: lon)

    }

    override func viewWillAppear(_ animated: Bool) {
        setBlueGradientBackground()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
//        updateWeather(latitude: lat, longitude: lon)
        self.locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error lm: \(error.localizedDescription)" )
    }
    
    func updateWeather(latitude: Double, longitude: Double){
        weatherViewModel.Weather.removeAll()
        weatherViewModel.getWeatherData(lat: latitude, lon: longitude)
//        print("weatherViewMode.getWeatherData: + \(weatherViewModel.getWeatherData(lat: lat, lon: lon))")
        let data = weatherViewModel.Weather
        print("ViewController.wetherViewNodelData.Weather = \(data)")
//        self.locationLabel.text = data.name ?? "Almaty"
//        self.conditionLabel.text = data.weather.main ?? "Sunny"
//        let iconName = data.weather.icon ?? "01d"
//        self.conditionImageView.image = UIImage(named: iconName)
//        self.tempLabel.text = "\(Int(round((data.main?.temp) ?? 0)))"
//
//        let date = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEEE"
//        self.dayLabel.text = dateFormatter.string(from: date)
//
//        let suffix = iconName.suffix(1)
//        if(suffix == "n"){
//            self.setGrayGradientBackground()
//        }else{
//            self.setBlueGradientBackground()
//        }
//        self.activityIndicator.stopAnimating()
    }
    func addSubviews() {
        self.view.addSubview(backgroundView)
        self.view.addSubview(locationLabel)
        self.view.addSubview(dayLabel)
        self.view.addSubview(conditionImageView)
        self.view.addSubview(conditionLabel)
        self.view.addSubview(tempLabel)
        self.view.addSubview(degreeLabel)
    }
    func setupConstraints(){
       locationLabel.translatesAutoresizingMaskIntoConstraints = false
       locationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
       locationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    
       dayLabel.translatesAutoresizingMaskIntoConstraints = false
       dayLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5).isActive = true
       dayLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    
       conditionImageView.translatesAutoresizingMaskIntoConstraints = false
       conditionImageView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 10).isActive = true
       conditionImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
       conditionImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
       conditionImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true

       conditionLabel.translatesAutoresizingMaskIntoConstraints = false
       conditionLabel.topAnchor.constraint(equalTo: conditionImageView.bottomAnchor, constant: 10).isActive = true
       conditionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

       tempLabel.translatesAutoresizingMaskIntoConstraints = false
       tempLabel.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 5).isActive = true
       tempLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

       degreeLabel.translatesAutoresizingMaskIntoConstraints = false
       degreeLabel.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 5).isActive = true
       degreeLabel.leftAnchor.constraint(equalTo: tempLabel.rightAnchor, constant: 5).isActive = true

       backgroundView.translatesAutoresizingMaskIntoConstraints = false
       backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
       backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
       backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
       backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
       let indicatorSize : CGFloat = 70
       let indicatorFrame = CGRect(x: (view.frame.width - indicatorSize)/2, y: (view.frame.height - indicatorSize)/2, width: indicatorSize, height: indicatorSize)
       activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20)
       activityIndicator.backgroundColor = .black
    }
    
    func setBlueGradientBackground(){
        let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    func setGrayGradientBackground(){
        let topColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
}

extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
      func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                             didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        let lat = place.coordinate.latitude
        let lon = place.coordinate.longitude
        UserDefaults.standard.set(place.name, forKey: "name")
        updateWeather(latitude: lat, longitude: lon)
      }
      func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                             didFailAutocompleteWithError error: Error){
                print("Error: ", error.localizedDescription)
      }
      func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
      }

      func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }
}
