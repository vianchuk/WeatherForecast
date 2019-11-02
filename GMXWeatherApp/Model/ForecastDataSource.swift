//
//  ForecastDataSource.swift
//  GMXWeatherApp
//
//  Created by Vitalii Ianchuk on 10/30/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import Foundation
import UIKit


protocol ForecastDataSourceProtocol : class {

    /// Request detail weather forecast
    /// - Parameter city: city description
    /// - Parameter country: country description
    /// - Parameter completion: response handler
    func fetchWeatherForecast(city: String,
                              country: String,
                              completion: @escaping (Result<[Forecast], Error>) -> Void)


    /// Request special weather image
    /// - Parameter name: image name
    /// - Parameter completion: response handler
    func fetchImage(name: String, completion: @escaping (Result<UIImage, Error>) -> Void)

}

final class ForecastDataSource : ForecastDataSourceProtocol {

    // MARK: - Properties

    private let forecastAPIClient : ForecastAPIClientProtocol

    // MARK: - Initialization
    
    init(forecastAPIClient: ForecastAPIClientProtocol) {
        self.forecastAPIClient = forecastAPIClient
    }

    // MARK: - ForecastDataSourceProtocol

    func fetchWeatherForecast(city: String,
                              country: String,
                              completion: @escaping (Result<[Forecast], Error>) -> Void) {
        forecastAPIClient.fetchForecast(parameters: ["q" : "\(city),\(country)"]) { result in
            switch result {
            case let .success(response):
                completion(.success(response))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }


    func fetchImage(name: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        forecastAPIClient.imageFor(name: name) { result in
            switch result {
            case let .success(image):
                completion(.success(image))
            case let .failure(error):
                 completion(.failure(error))
            }
        }
    }
}
