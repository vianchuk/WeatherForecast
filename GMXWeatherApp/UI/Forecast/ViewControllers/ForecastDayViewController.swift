//
//  ForecastDayViewController.swift
//  GMXWeatherApp
//
//  Created by Vitalii Ianchuk on 10/31/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import Foundation
import UIKit


final class ForecastDayViewController : UIViewController {

    // MARK: - IBOutlets

     @IBOutlet weak private var nameLabel: UILabel!
     @IBOutlet weak private var collectionView: UICollectionView!

    // MARK: - Properties

    private let controller: ForecastDayController


    // MARK: - Initialization

    init(controller: ForecastDayController) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = controller.dayDescription

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = controller
        collectionView.register(ForecastDayCollectionViewCell.nib, forCellWithReuseIdentifier: ForecastDayCollectionViewCell.reuseIdentifier)

        collectionView.reloadData()
    }
}
