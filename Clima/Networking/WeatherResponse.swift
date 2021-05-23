//
//  WeatherData.swift
//  Clima
//
//  Created by Sebastian Fernandez on 20/05/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherResponse: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
    let description: String
    
}
