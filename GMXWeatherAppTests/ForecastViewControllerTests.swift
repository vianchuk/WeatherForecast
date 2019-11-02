//
//  ForecastViewControllerTests.swift
//  GMXWeatherAppTests
//
//  Created by Vitalii Ianchuk on 11/2/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import XCTest
@testable import GMXWeatherApp


final class ForecastViewControllerTests : XCTestCase {

    private var viewController: ForecastViewController!
    private var controller: MockForecastController!

    override func setUp() {
        super.setUp()
        controller = MockForecastController()
        viewController = ForecastViewController(controller: controller)
    }

    override func tearDown() {
        controller = nil
        viewController = nil

        super.tearDown()
    }

    func test_loadForecastData() {
        viewController.viewDidLoad()
        XCTAssertTrue(controller.stubFetchWeatherForecastWasCalled)
    }

}
