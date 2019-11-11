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
    var forecastDataStorage: MockForecastDataStorage!
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
        forecastDataStorage = MockForecastDataStorage()
        forecastDataSource = ForecastDataSource(forecastAPIClient: forecastAPIClient, forecastDataStorage: forecastDataStorage)
    }

    override func tearDown() {
        forecastAPIClient = nil
        forecastDataSource = nil
        forecastDataStorage = nil

        super.tearDown()
    }

    func test_fetchWeatherForecastSuccess() {
        forecastAPIClient.stubFetchForecastCompletion = .success([mockForecast])
        forecastDataSource.fetchWeatherForecast(fromLocalFile: false, city: "test", country: "test") { result in
            if case .failure = result {
                XCTAssertThrowsError("expected success result")
            }
        }

        XCTAssertTrue(forecastAPIClient.stubFetchForecastWasCalled)
        XCTAssertFalse(forecastDataStorage.stubFetchForecastFromLocalFileWasCalled)
    }

    func test_fetchWeatherForecastFail() {
        forecastDataSource.fetchWeatherForecast(fromLocalFile: false, city: "test", country: "test") { result in
            if case .success = result {
                XCTAssertThrowsError("expected fail result")
            }
        }

        XCTAssertTrue(forecastAPIClient.stubFetchForecastWasCalled)
        XCTAssertFalse(forecastDataStorage.stubFetchForecastFromLocalFileWasCalled)
    }

    func test_fetchWeatherForecastFromLocalFileSuccess() {
        forecastDataStorage.stubFetchForecastFromLocalFileCompletion = .success([mockForecast])
        forecastDataSource.fetchWeatherForecast(fromLocalFile: true, city: "test", country: "test") { result in
            if case .failure = result {
                XCTAssertThrowsError("expected success result")
            }
        }

        XCTAssertFalse(forecastAPIClient.stubFetchForecastWasCalled)
        XCTAssertTrue(forecastDataStorage.stubFetchForecastFromLocalFileWasCalled)
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
