//
//  CitiesTableViewController.swift
//  GMXWeatherApp
//
//  Created by Vitalii Ianchuk on 10/31/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import Foundation
import UIKit

final class CitiesTableViewController : UITableViewController {

    // MARK: - Properties

    private let controller: CitiesController

    init(controller: CitiesController) {
        self.controller = controller

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        tableView.delegate = controller
        tableView.dataSource = controller
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cityCellIdentifier")

        super.viewDidLoad()
    }

}
