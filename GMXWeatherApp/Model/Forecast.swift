//
//  Weather.swift
//  GMXWeatherApp
//
//  Created by Vitalii Ianchuk on 10/30/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import Foundation

struct City : Codable {
    let name: String
    let country: String
}

struct Main : Codable {
    let temp : Double
    let temp_min : Double
    let temp_max : Double
}

struct Weather : Codable {
    let main : String
    let description : String
    let icon: String
}

struct Forecast : Codable {
    let date : Double
    let main : Main
    let weather : [Weather]

    enum CodingKeys : String, CodingKey {
        case date = "dt"
        case main
        case weather
    }
}

struct APIResponse : Codable {
    let message : Int
    let list : [Forecast]
    let city : City
}
