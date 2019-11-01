//
//  ForecastViewController.swift
//  GMXWeatherApp
//
//  Created by Vitalii Ianchuk on 10/30/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import Foundation
import UIKit

final class ForecastViewController : UIViewController {

    // MARK: - Properties

    private let dayForecastViewHeight: CGFloat = 130
    private let controller: ForecastControllerProtocol
    private let scrollView: UIScrollView

    private var loadingViewController: LoadingViewController
    private var forecastChildViewControllers: [UIViewController] = []

    // MARK: - Initialization

    init(controller : ForecastControllerProtocol) {
        self.controller = controller
        self.scrollView = UIScrollView()

        self.loadingViewController = LoadingViewController()
        self.loadingViewController.view.translatesAutoresizingMaskIntoConstraints = false

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        scrollView.backgroundColor = .systemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: view.bounds.height),
            scrollView.widthAnchor.constraint(equalToConstant: view.bounds.width)
        ])

        loadForecastData()
    }

    // MARK: - Private helpers

    private func setupNavigationBar() {
        let button = UIBarButtonItem(title: NSLocalizedString("forecast.cities.button.title", comment: "title"), style: .plain, target: self, action: #selector(showCitiesAction(_:)))
        navigationItem.rightBarButtonItem = button
    }

    private func configureLoadingViewController(isVisible: Bool) {
        if isVisible {
            addChild(loadingViewController)
            loadingViewController.didMove(toParent: self)
            view.addSubview(loadingViewController.view)
            NSLayoutConstraint.activate([
                loadingViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
                loadingViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
                loadingViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
                loadingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        } else {
            loadingViewController.willMove(toParent: nil)
            loadingViewController.view.removeFromSuperview()
            loadingViewController.removeFromParent()
        }
    }

    @objc private func showCitiesAction(_ sender: UIBarButtonItem) {
        let citiesViewController = controller.citiesControllerViewController() { [weak self] in
            self?.dismiss(animated: true, completion: nil)
            self?.clearView()
            self?.loadForecastData()
        }
        present(citiesViewController, animated: true, completion: nil)
    }

    private func loadForecastData() {
        configureLoadingViewController(isVisible: true)
        controller.fetchWeatherForecast() { [weak self] (result) in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.setupForecastWeatherViews()
                    self?.configureLoadingViewController(isVisible: false)
                }
            case .failure:
                // TODO: - Process failing case
                self?.configureLoadingViewController(isVisible: false)
            }
        }
    }

    private func setupForecastWeatherViews() {
        var currentTopAnchor = scrollView.topAnchor

        navigationItem.title = String(format: NSLocalizedString("forecast.navigation.title", comment: ""), controller.currentCityInfo)
        for day in 0...4 {
            guard let viewController = controller.dayForecastController(day: day) else {
                return
            }

            addChild(viewController)
            viewController.didMove(toParent: self)
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(viewController.view)

            NSLayoutConstraint.activate([
                viewController.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
                viewController.view.topAnchor.constraint(equalTo: currentTopAnchor),
                viewController.view.heightAnchor.constraint(equalToConstant: dayForecastViewHeight),
                viewController.view.widthAnchor.constraint(equalToConstant: view.bounds.width)
            ])

            currentTopAnchor = viewController.view.bottomAnchor

            forecastChildViewControllers.append(viewController)
        }
    }

    private func clearView() {
        for viewController in forecastChildViewControllers {
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }

        forecastChildViewControllers.removeAll()
    }

}

