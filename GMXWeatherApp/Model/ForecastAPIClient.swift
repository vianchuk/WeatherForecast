//
//  ForecastAPIClient.swift
//  GMXWeatherApp
//
//  Created by Vitalii Ianchuk on 10/30/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import Foundation
import UIKit

protocol ForecastAPIClientProtocol : class {

    /// Request weather forecast for detailed parameters
    /// - Parameter parameters: forecast description parameters
    /// - Parameter completion: completion handlder
    func fetchForecast(parameters: URLParameters,  completion: @escaping (Result<[Forecast], Error>) -> Void)

    /// Request forecast day image
    /// - Parameter name: image name
    /// - Parameter completion: requeest result
    func imageFor(name: String,  completion: @escaping (Result<UIImage, Error>) -> Void)
}

final class  ForecastAPIClient : ForecastAPIClientProtocol {

    // MARK: - Properties

    private let client : ApiClient

    // MARK: - Initialization

    init(client: ApiClient) {
        self.client = client
    }

    // MARK: - ForecastAPIClientProtocol

    func fetchForecast(parameters: URLParameters, completion: @escaping (Result<[Forecast], Error>) -> Void) {
        let route = GMXEndPoint(httpMethod: .get, path: "/data/2.5/forecast", parameters: parameters)
        client.apiRequest(route) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let responseData = data else {
                completion(.failure(NSError())) // TODO: - Error description needed
                return
            }
            do {
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: responseData)
                completion(.success(apiResponse.list))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func imageFor(name: String,  completion: @escaping (Result<UIImage, Error>) -> Void) {
        let route = GMXEndPoint(httpMethod: .get, path: String(format: "/img/wn/%@@2x.png", name) , parameters: [:])
        client.serviceRequest(route) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let responseData = data else {
                completion(.failure(NSError())) // TODO: - Error description needed
                return
            }

            guard let image = UIImage(data: responseData) else {
                completion(.failure(NSError())) // TODO: - Error description needed
                return
            }
            completion(.success(image))
        }
    }
}
