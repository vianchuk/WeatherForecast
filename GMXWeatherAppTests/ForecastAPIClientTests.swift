//
//  GMXWeatherAppTests.swift
//  GMXWeatherAppTests
//
//  Created by Vitalii Ianchuk on 10/30/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import XCTest
@testable import GMXWeatherApp

class ForecastAPIClientTests : XCTestCase {

    private var client : MockGMXAPIClient!
    private var forecastApiClient : ForecastAPIClient!

    override func setUp() {
        super.setUp()

        client = MockGMXAPIClient()
        forecastApiClient = ForecastAPIClient(client: client)
    }

    override func tearDown() {
        client = nil
        forecastApiClient = nil

        super.tearDown()
    }

    func test_fetchForecast() {
        forecastApiClient.fetchForecast(parameters: [:]) { _ in }
        XCTAssert(client.stubApiRequestWasCalled)
    }

}
