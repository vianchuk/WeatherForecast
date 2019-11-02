//
//  MockForecastController.swift
//  GMXWeatherAppTests
//
//  Created by Vitalii Ianchuk on 11/2/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import Foundation
@testable import GMXWeatherApp

final class MockForecastController : ForecastControllerProtocol {

    var stubFetchWeatherForecastWasCalled = false
    var stubFetchWeatherForecastCompletion: (Result<Any?, Error>) = .failure(NSError())
    func fetchWeatherForecast(completion: @escaping (Result<Any?, Error>) -> Void) {
        stubFetchWeatherForecastWasCalled = true
        completion(stubFetchWeatherForecastCompletion)
    }

    var stubDayForecastControllerWasCalled = false
    func dayForecastController(day: Int) -> ForecastDayViewController? {
        stubDayForecastControllerWasCalled = true
        return nil
    }

    var stubCitiesControllerViewController = false
    func citiesControllerViewController(completion: @escaping (() -> Void)) -> CitiesTableViewController {
        stubCitiesControllerViewController = true
        let controller = CitiesTableViewController(controller: CitiesController(completion: {_,_ in }))
        return controller
    }

    var currentCityInfo: String = "testablecity"

    
}
