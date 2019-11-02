//
//  ForecastDayController.swift
//  GMXWeatherApp
//
//  Created by Vitalii Ianchuk on 10/31/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import Foundation
import UIKit


protocol ForecastDayControllerProtocol {

    var dayDescription: String { get }

}

final class ForecastDayController : NSObject, ForecastDayControllerProtocol {

    // MARK: - Properties

    private let day: String
    private let forecast: [Forecast]
    private let dataSource: ForecastDataSourceProtocol

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        formatter.setLocalizedDateFormatFromTemplate("HH:mm")
        return formatter
    }()

    // MARK: - ForecastDayController

    var dayDescription: String {
        return day
    }

    // MARK: - Initialization

    init(day: String, forecast: [Forecast], dataSource: ForecastDataSourceProtocol) {
        self.day = day
        self.forecast = forecast
        self.dataSource = dataSource
    }
}

// MARK: UICollectionViewDataSource

extension ForecastDayController : UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecast.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastDayCollectionViewCell.reuseIdentifier, for: indexPath) as! ForecastDayCollectionViewCell
        let currentForecast = forecast[indexPath.row]
        let date = Date(timeIntervalSince1970: currentForecast.date)
        let celsiusTemp =  currentForecast.main.temp - 273.15
        cell.configure(with: dateFormatter.string(from: date), temperature: String(format: "%.0f", celsiusTemp), weatherImage: nil)
        dataSource.fetchImage(name: currentForecast.weather[0].icon) { result in
            switch result {
            case let .success(image):
                DispatchQueue.main.async {
                    cell.updateImage(image: image)
                }
            case .failure(_):
                break // TODO: fail image proccess
            }

        }
        return cell
    }

}
