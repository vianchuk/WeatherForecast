//
//  GMXAPIClientTests.swift
//  GMXWeatherAppTests
//
//  Created by Vitalii Ianchuk on 11/2/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import XCTest
@testable import GMXWeatherApp


final class ForecastDataSourceTests : XCTestCase {

    var forecastAPIClient: MockForecastAPIClient!
    var forecastDataSource: ForecastDataSource!

    lazy var mockForecast: Forecast = {
        let double = Double.random(in: 0...10000)
        let str = "mockstring"

        let main = Main(temp: double, temp_min: double, temp_max: double)
        let weather = Weather(main: str, description: str, icon: str)
        return Forecast(date: double, main: main, weather: [weather])
    }()

    override func setUp() {
        super.setUp()

        forecastAPIClient = MockForecastAPIClient()
        forecastDataSource = ForecastDataSource(forecastAPIClient: forecastAPIClient)
    }

    override func tearDown() {
        forecastAPIClient = nil
        forecastDataSource = nil

        super.tearDown()
    }

    func test_fetchWeatherForecastSuccess() {
        forecastAPIClient.stubFetchForecastCompletion = .success([mockForecast])
        forecastDataSource.fetchWeatherForecast(city: "test", country: "test") { result in
            if case .failure = result {
                XCTAssertThrowsError("expected success result")
            }
        }

        XCTAssertTrue(forecastAPIClient.stubFetchForecastWasCalled)
    }

    func test_fetchWeatherForecastFail() {
           forecastDataSource.fetchWeatherForecast(city: "test", country: "test") { result in
               if case .success = result {
                   XCTAssertThrowsError("expected fail result")
               }
           }

           XCTAssertTrue(forecastAPIClient.stubFetchForecastWasCalled)
       }

    func test_fetchImageFailure() {
        forecastDataSource.fetchImage(name: "") { result in
            if case .success = result {
                XCTAssertThrowsError("expected fail result")
            }
        }

        XCTAssertTrue(forecastAPIClient.stubImageForWasCalled)
    }

}
