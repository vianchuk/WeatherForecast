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
    func fetchForecast(parameters: URLParameters,  completion: @escaping (Result<[Forecast], Error>) -> Void)
    func imageFor(name: String,  completion: @escaping (Result<UIImage, Error>) -> Void)
}

final class  ForecastAPIClient : ForecastAPIClientProtocol {

    private let client : ApiClient

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
                completion(.failure(NSError()))
                return
            }
            do {
                let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                print(jsonData)
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
                completion(.failure(NSError()))
                return
            }

            guard let image = UIImage(data: responseData) else {
                completion(.failure(NSError()))
                return
            }
            completion(.success(image))
        }
    }
}
