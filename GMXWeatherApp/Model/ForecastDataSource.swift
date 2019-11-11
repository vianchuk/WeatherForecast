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
    /// - Parameter fromLocalFile: is data fethced from local file
    /// - Parameter city: city description
    /// - Parameter country: country description
    /// - Parameter completion: response handler
    func fetchWeatherForecast(fromLocalFile: Bool,
                              city: String,
                              country: String,
                              completion: @escaping (ForecastLoadingResult) -> Void)


    /// Request special weather image
    /// - Parameter name: image name
    /// - Parameter completion: response handler
    func fetchImage(name: String, completion: @escaping (ForecastImageLoadingResult) -> Void)

}

final class ForecastDataSource : ForecastDataSourceProtocol {

    // MARK: - Properties

    private let forecastAPIClient : ForecastAPIClientProtocol
    private let forecastDataStorage: ForecastDataStorageProtocol
    private let dafaultForecastLocalFileName = "localForecast"

    // MARK: - Initialization
    
    init(forecastAPIClient: ForecastAPIClientProtocol,
         forecastDataStorage: ForecastDataStorageProtocol) {
        self.forecastAPIClient = forecastAPIClient
        self.forecastDataStorage = forecastDataStorage
    }

    // MARK: - ForecastDataSourceProtocol

    func fetchWeatherForecast(fromLocalFile: Bool,
                              city: String,
                              country: String,
                              completion: @escaping (ForecastLoadingResult) -> Void) {

        if fromLocalFile {
            forecastDataStorage.fetchForecastFromLocalFile(name: dafaultForecastLocalFileName) { result in
                switch result {
                case let .success(response):
                    completion(.success(response))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        } else {
            forecastAPIClient.fetchForecast(parameters: ["q" : "\(city),\(country)"]) { result in
                switch result {
                case let .success(response):
                    completion(.success(response))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }


    func fetchImage(name: String, completion: @escaping (ForecastImageLoadingResult) -> Void) {
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
