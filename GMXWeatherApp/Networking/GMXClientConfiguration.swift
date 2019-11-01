//
//  ClientConfiguration.swift
//  GMXWeatherApp
//
//  Created by Vitalii Ianchuk on 10/30/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import Foundation

protocol ClientConfiguration {
    var baseAppURL : String { get }
    var baseApiURL : String { get }
    var apiKey : String { get }
}

struct GMXClientConfiguration : ClientConfiguration {
    let baseAppURL : String = "https://openweathermap.org"
    let baseApiURL : String = "https://api.openweathermap.org"
    let apiKey : String = "c15a1cf7d0719d0b26f310fb2b6d9da1"
}


