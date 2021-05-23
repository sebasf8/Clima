//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    //MARK: - Properties
    private var weatherManager = WeatherManager()
    private var locationManager = CLLocationManager()
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func searchAction(_ sender: Any) {
        weatherManager.fetchWeather(from: searchTextField.text!)
        
        searchTextField.endEditing(true)

    }
    @IBAction func currentLocationAction(_ sender: Any) {
        locationManager.requestLocation()
    }
    
}

//MARK: - UITextfieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        weatherManager.fetchWeather(from: searchTextField.text!)
        searchTextField.endEditing(true)
        return true
    }
    
        func textFieldDidEndEditing(_ textField: UITextField) {
            searchTextField.text = ""
        }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateWeather(_: WeatherManager, weather: WeatherModel) {
        temperatureLabel.text = weather.temperatureString
        cityLabel.text = weather.name
        conditionImageView.image = UIImage(systemName: weather.conditionName)
    }
}

//MARK: -
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            weatherManager.fetchWeatherAt(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

