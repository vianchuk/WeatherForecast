//
//  LoadingViewController.swift
//  GMXWeatherApp
//
//  Created by Vitalii Ianchuk on 11/1/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import Foundation
import UIKit


final class LoadingViewController : UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var loadingIndicator: UIActivityIndicatorView!


    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = NSLocalizedString("forecast.loading.description", comment: "")
        loadingIndicator.startAnimating()
    }
}
