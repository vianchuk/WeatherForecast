//
//  ForecastController.swift
//  GMXWeatherApp
//
//  Created by Vitalii Ianchuk on 10/30/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import Foundation
import UIKit

protocol ForecastControllerProtocol {

    /// Fetch all weather info
    /// - Parameter completion: completion handler
    func fetchWeatherForecast(completion: @escaping (Result<Any?, Error>) -> Void)


    /// Generate forecast view controller for specific day
    /// - Parameter day: day description
    func dayForecastController(day: Int) -> ForecastDayViewController?

    /// Generate cities view controller
    /// - Parameter completion: completion handler
    func citiesControllerViewController(completion: @escaping (() -> Void)) -> CitiesTableViewController

    /// Return current city information
    var currentCityInfo: String { get }
}

final class ForecastController : ForecastControllerProtocol {

    // MARK: - Properties

    private let dataSource: ForecastDataSourceProtocol
    private var forecastList: [Forecast] = []
    private var city: String = "London" // default value
    private var country: String = "us"  // default value

    // MARK: - Initialization

    init(dataSource: ForecastDataSourceProtocol) {
        self.dataSource = dataSource
    }

    // MARK: - ForecastControllerProtocol

    var currentCityInfo: String {
        return city
    }

    func citiesControllerViewController(completion: @escaping (() -> Void)) -> CitiesTableViewController {
        let citiesCompletion: CitiesCompletion = { [weak self] city, country in
            self?.city = city
            self?.country = country
            completion()
        }

        let citiesController = CitiesController(completion: citiesCompletion)
        let citiesViewController = CitiesTableViewController(controller: citiesController)
        return citiesViewController
    }

    func fetchWeatherForecast(completion:  @escaping (Result<Any?, Error>) -> Void) {
        dataSource.fetchWeatherForecast(city: city, country: country) { [weak self] result in
            switch result {
            case let .success(response):
                self?.forecastList = response
                completion(.success(nil))
            case .failure:
                break // TODO: - Process failing case
            }
        }
    }

    func dayForecastController(day: Int) -> ForecastDayViewController? {
        let calendar = Calendar.current
        let currentDayCalendarComponent = DateComponents(day: day)
        guard let date = calendar.date(byAdding: currentDayCalendarComponent, to: Date()) else {
            return nil
        }
        let dateDayStart = calendar.startOfDay(for: date)
        let endDayCalendarComponent = DateComponents(day: 1, second: -1)
        guard let dateDayEnd = calendar.date(byAdding: endDayCalendarComponent, to: dateDayStart) else {
            return nil
        }
        let forecast = forecastList.filter({ $0.date >= dateDayStart.timeIntervalSince1970 && $0.date <= dateDayEnd.timeIntervalSince1970 })
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        let day = dateFormatter.string(from: dateDayStart)

        let forecastDayController = ForecastDayController(day: day, forecast: forecast, dataSource: dataSource)
        return ForecastDayViewController(controller: forecastDayController)
    }
    
}

