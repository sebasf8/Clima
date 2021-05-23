//
//  WeatherManager.swift
//  Clima
//
//  Created by Sebastian Fernandez on 20/05/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    var session: URLSession = URLSession.shared
    
    func fetchWeather(from cityName: String) {
        guard let url = URL(string: "\(Constants.api.baseURL)&q=\(cityName)") else {
            fatalError("Malformed URL")
        }
        print(url)
        fetchRequest(url)
    }
    
    func fetchWeatherAt(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        guard let url = URL(string: "\(Constants.api.baseURL)&lat=\(latitude)&lon=\(longitude)") else {
            fatalError("Malformed URL")
        }
        
        print(url)
        
        fetchRequest(url)
    }
}

//MARK: - Private methods
extension WeatherManager {
    private func fetchRequest(_ url:
                            URL) {
        let task = session.dataTask(with: url) { data, repose, error in
            guard error == nil else {
                //completion(nil, error)
                delegate?.didFailWithError(error: error!)
                return
            }
            
            guard let data = data else {
                //completion(nil, NSError(domain: "No data", code: 10, userInfo: nil))
                delegate?.didFailWithError(error: NSError(domain: "No data", code: 10, userInfo: nil))
                return
            }
            
            if let weather = self.parseJSON(_: data) {
                DispatchQueue.main.async {
                    delegate?.didUpdateWeather(self, weather: weather)
                }
            }
        }
        
        task.resume()
    }
    
    private func parseJSON(_ data: Data) -> WeatherModel? {
        do {
            let decoder = JSONDecoder()
            let response =  try decoder.decode(WeatherResponse.self, from: data)
            
            return WeatherModel(id: response.weather[0].id, name: response.name, description: response.weather[0].description, temp: response.main.temp)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
