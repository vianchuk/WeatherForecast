//
//  ForecastDayCollectionVIewCell.swift
//  GMXWeatherApp
//
//  Created by Vitalii Ianchuk on 10/31/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import Foundation
import UIKit

final class ForecastDayCollectionViewCell : UICollectionViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak private var timeLabel: UILabel!
    @IBOutlet weak private var temperatureLabel: UILabel!
    @IBOutlet weak private var weatherImageView: UIImageView!

    // MARK: - Public methods

    /// Cell configuration method
    /// - Parameter time: forecast time
    /// - Parameter temperature: forecast temperature
    /// - Parameter weatherImage: forecast weather image
    func configure(with time: String, temperature: String, weatherImage: UIImage?) {
        timeLabel.text = time
        temperatureLabel.text = temperature
        weatherImageView.image = weatherImage
    }


    /// Update cell image
    /// - Parameter image: new image
    func updateImage(image: UIImage) {
        weatherImageView.image = image
    }
    
    // MARK: Static variable

    static var reuseIdentifier: String = "ForecastDayCollectionViewCellIdentifier"
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
