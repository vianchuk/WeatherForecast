//
//  GMXEndPoint.swift
//  GMXWeatherApp
//
//  Created by Vitalii Ianchuk on 10/30/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import Foundation

typealias URLParameters  = [String : String]

enum HTTPMethod : String {
    case get   = "GET"
    case post  = "POST"
}

protocol EndPoint {
    var httpMethod: HTTPMethod { get }
    var path: String { get }
    var parameters: URLParameters { get }
}

struct GMXEndPoint : EndPoint {
    let httpMethod: HTTPMethod
    let path: String
    let parameters: URLParameters
}
