//
//  MockForecastDataStorage.swift
//  GMXWeatherAppTests
//
//  Created by Vitalii Ianchuk on 11/9/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import Foundation
@testable import GMXWeatherApp

final class MockForecastDataStorage : ForecastDataStorageProtocol {
    var stubFetchForecastFromLocalFileWasCalled = false
    var stubFetchForecastFromLocalFileCompletion: (ForecastLoadingResult) = .failure(NSError())

    func fetchForecastFromLocalFile(name: String, completion: @escaping (ForecastLoadingResult) -> Void) {
        stubFetchForecastFromLocalFileWasCalled = true
        completion(stubFetchForecastFromLocalFileCompletion)
    }
}
