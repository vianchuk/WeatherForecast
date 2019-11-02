//
//  CitiesController\.swift
//  GMXWeatherApp
//
//  Created by Vitalii Ianchuk on 10/31/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import Foundation
import UIKit

typealias CitiesCompletion = (_ city: String, _ region: String)->()

enum CityEnum : String {
    case london = "London"
    case munich = "Munich"
    case kyiv = "Kyiv"
}

final class CitiesController : NSObject {

    private let completion: CitiesCompletion
    private let cities: [CityEnum] = [.london, .munich, .kyiv]


    init(completion: @escaping CitiesCompletion) {
        self.completion = completion
    }
    
}

// MARK: - UITableViewDelegate

extension CitiesController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        let region: String = {
            switch city {
            case .london:
                return "us"
            case .munich:
                return "de"
            case .kyiv:
                return "ua"
            }
        }()

        completion(city.rawValue, region)
    }

}

// MARK: - UITableViewDataSource

extension CitiesController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCellIdentifier", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row].rawValue
        return cell
    }

}
