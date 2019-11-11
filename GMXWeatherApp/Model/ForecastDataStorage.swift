//
//  ForecastDataStorage.swift
//  GMXWeatherApp
//
//  Created by Vitalii Ianchuk on 11/6/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import Foundation


protocol ForecastDataStorageProtocol : class {

    /// Fetch forecast from local bundle file
    /// - Parameter name: .json file name
    /// - Parameter completion: completion result
    func fetchForecastFromLocalFile(name: String, completion: @escaping (ForecastLoadingResult) -> Void)
}


final class ForecastDataStorage : ForecastDataStorageProtocol {

    func fetchForecastFromLocalFile(name: String, completion: @escaping (ForecastLoadingResult) -> Void) {
        guard let path = Bundle.main.path(forResource: name, ofType: ".json") else {
            completion(.failure(ForecastError.invalidLocalPath))
            return
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let foreast = try JSONDecoder().decode(APIResponse.self, from: data)
            completion(.success(foreast.list))
        } catch {
            completion(.failure(error))
        }
    }

}
