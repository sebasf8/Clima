//
//  MockWeatherManagerDelegate.swift
//  ClimaTests
//
//  Created by Sebastian Fernandez on 22/05/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import XCTest
@testable import Clima

class MockWeatherManagerDelegate: WeatherManagerDelegate {
    var weather: WeatherModel?
    var error: Error?
    var expectation: XCTestExpectation?
    
    init(expectation: XCTestExpectation) {
        self.expectation = expectation
    }
    
    func didUpdateWeather(_: WeatherManager, weather: WeatherModel) {
        self.weather = weather
        expectation?.fulfill()
    }
    
    func didFailWithError(error: Error) {
        self.error = error
        expectation?.fulfill()
    }
}
