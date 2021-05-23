//
//  ClimaTests.swift
//  ClimaTests
//
//  Created by Sebastian Fernandez on 22/05/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import XCTest
@testable import Clima

class WeatherManagerTestSuit: XCTestCase {
    var sut: WeatherManager!
    override func setUpWithError() throws {
        sut = WeatherManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchWeatherWithExpectedUrlHostAndPath() throws {
        let mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        sut.session = mockURLSession
        sut.fetchWeather(from: "Madrid")

        XCTAssertEqual(mockURLSession.cachedUrl?.host, "api.openweathermap.org")
        XCTAssertEqual(mockURLSession.cachedUrl?.path, "/data/2.5/weather")
    }

    func testFetchWeatherSuccess() throws {
        let jsonData = """
        {
          "coord": {
            "lon": -3.7026,
            "lat": 40.4165
          },
          "weather": [
            {
              "id": 800,
              "main": "Clear",
              "description": "clear sky",
              "icon": "01d"
            }
          ],
          "base": "stations",
          "main": {
            "temp": 18.37,
            "feels_like": 16.99,
            "temp_min": 15.98,
            "temp_max": 20.13,
            "pressure": 1016,
            "humidity": 28
          },
          "visibility": 10000,
          "wind": {
            "speed": 1.34,
            "deg": 203,
            "gust": 1.79
          },
          "clouds": {
            "all": 0
          },
          "dt": 1621678746,
          "sys": {
            "type": 2,
            "id": 2007545,
            "country": "ES",
            "sunrise": 1621659165,
            "sunset": 1621711832
          },
          "timezone": 7200,
          "id": 3117735,
          "name": "Madrid",
          "cod": 200
        }
        """.data(using: .utf8)

        let mockURLSession = MockURLSession(data: jsonData, urlResponse: nil, error: nil)
        sut.session = mockURLSession
        let weatherExpectation = expectation(description: "weather")
        sut.delegate = MockWeatherManagerDelegate(expectation: weatherExpectation)
        
        sut.fetchWeather(from: "Madrid")

        waitForExpectations(timeout: 1)
        
        let result = try XCTUnwrap((sut.delegate as! MockWeatherManagerDelegate).weather)
        XCTAssertNotNil(result)
    }

    func testFetchWeatherError() throws {
        let error = NSError(domain: "error", code: 1234, userInfo: nil)
        let mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: error)
        sut.session = mockURLSession

        let errorExpectation = expectation(description: "error")
        sut.delegate = MockWeatherManagerDelegate(expectation: errorExpectation)

        sut.fetchWeather(from: "London")

        waitForExpectations(timeout: 1)
        
        let errorResponse = try XCTUnwrap((sut.delegate as! MockWeatherManagerDelegate).error)
        let result = (sut.delegate as! MockWeatherManagerDelegate).weather
        
        XCTAssertNotNil(errorResponse)
        XCTAssertNil(result)
    }

    func testFetchWeatherEmptyDataError() throws {
        let mockUrlSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        sut.session = mockUrlSession

        let emptyDataExpectation = expectation(description: "emptyData")
        sut.delegate = MockWeatherManagerDelegate(expectation: emptyDataExpectation)
        
        sut.fetchWeather(from: "Paris")

        waitForExpectations(timeout: 1)
        
        let errorResponse = try XCTUnwrap((sut.delegate as! MockWeatherManagerDelegate).error)
        let result = (sut.delegate as! MockWeatherManagerDelegate).weather
        
        XCTAssertNotNil(errorResponse)
        XCTAssertNil(result)
    }

    func testFetchWeatherInvalidJSONReturnsError() throws {
        let jsonData = "{\"t\"}".data(using: .utf8)
        let mockURLSession  = MockURLSession(data: jsonData, urlResponse: nil, error: nil)
        sut.session = mockURLSession
        let errorExpectation = expectation(description: "error")

        sut.delegate = MockWeatherManagerDelegate(expectation: errorExpectation)
        sut.fetchWeather(from: "London")

        waitForExpectations(timeout: 1)
        let errorResponse = try XCTUnwrap((sut.delegate as! MockWeatherManagerDelegate).error)
        let result = (sut.delegate as! MockWeatherManagerDelegate).weather
        
        XCTAssertNotNil(errorResponse)
        XCTAssertNil(result)
    }

}
