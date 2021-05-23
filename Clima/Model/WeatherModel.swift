//
//  Weather.swift
//  Clima
//
//  Created by Sebastian Fernandez on 20/05/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let name: String
    let description: String
    let temperature: Double
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    var conditionName: String {
        switch conditionId {
        case 200...299:
            return "cloud.bolt.rain"
        case 300...399:
            return "cloud.drizzle"
        case 500...599:
            return "cloud.rain"
        case 600...699:
            return "cloud.snow"
        case 800:
            return "sun.max"
        case 801...890:
            return "cloud.sun"
        default:
            return "cloud"
        }
    }

    init(id: Int, name: String, description: String, temp: Double) {
        self.conditionId = id
        self.name = name
        self.description = description
        self.temperature = temp
    }
    
}
