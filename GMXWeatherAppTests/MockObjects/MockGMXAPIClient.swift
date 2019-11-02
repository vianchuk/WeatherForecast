//
//  MockGMXAPIClient.swift
//  GMXWeatherAppTests
//
//  Created by Vitalii Ianchuk on 11/2/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import Foundation
@testable import GMXWeatherApp


final class MockGMXAPIClient : ApiClient {

    var stubApiRequestWasCalled = false
    func apiRequest(_ route: EndPoint, completion: @escaping NetworkCompletion) {
        stubApiRequestWasCalled = true
    }

    var stubCancelRequestWasCalled = false
    func serviceRequest(_ route: EndPoint, completion: @escaping NetworkCompletion) {
        stubApiRequestWasCalled = true
    }

    var stubCancelWasCalled = false
    func cancel() {
        stubCancelWasCalled = true
    }
    
}
