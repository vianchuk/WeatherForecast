//
//  APIClient.swift
//  GMXWeatherApp
//
//  Created by Vitalii Ianchuk on 10/30/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import Foundation

typealias NetworkCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol ApiClient : class {

    /// Network request to api services
    /// - Parameter route: base route
    /// - Parameter completion: completion handler
    func apiRequest(_ route: EndPoint, completion: @escaping NetworkCompletion)

    /// Network request to general services
    /// - Parameter route: base route
    /// - Parameter completion: completion handler
    func serviceRequest(_ route: EndPoint, completion: @escaping NetworkCompletion)

    /// Cancel network request
    func cancel()
}

class GMXAPIClient : ApiClient {

    private let configuration: ClientConfiguration
    private var task: URLSessionTask?

    init(configuration: ClientConfiguration) {
        self.configuration = configuration
    }

    // MARK: - ApiClient

    func apiRequest(_ route: EndPoint, completion: @escaping NetworkCompletion) {
        let session = URLSession.shared
        do {
            let request = try buildRequest(route, configuration.baseApiURL)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        task?.resume()
    }

    func serviceRequest(_ route: EndPoint, completion: @escaping NetworkCompletion) {
        let session = URLSession.shared
        do {
            let request = try buildRequest(route, configuration.baseAppURL)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        task?.resume()
    }

    func cancel() {
        task?.cancel()
    }

    // MARK: - Private helpers

    private func buildRequest(_ route: EndPoint, _ baseURL: String) throws -> URLRequest {
        let urlComponents = NSURLComponents(string: baseURL)
        urlComponents?.path = route.path
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "appid", value: configuration.apiKey))
        for (key, value) in route.parameters {
             queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponents?.queryItems = queryItems

        guard let requestURL = urlComponents?.url else {
            throw NSError() // TODO: - Error description needed
        }
        return URLRequest(url: requestURL)
    }

}

