//
//  MockForecastAPIClient.swift
//  GMXWeatherAppTests
//
//  Created by Vitalii Ianchuk on 11/2/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import UIKit
@testable import GMXWeatherApp


final class MockForecastAPIClient: ForecastAPIClientProtocol {

    var stubFetchForecastWasCalled = false
    var stubFetchForecastCompletion: (Result<[Forecast], Error>) = .failure(NSError())
    func fetchForecast(parameters: URLParameters, completion: @escaping (Result<[Forecast], Error>) -> Void) {
        stubFetchForecastWasCalled = true
        completion(stubFetchForecastCompletion)
    }

    var stubImageForWasCalled = false
    var stubImageFor: (Result<UIImage, Error>) = .failure(NSError())
    func imageFor(name: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        stubImageForWasCalled = true
    }

}
