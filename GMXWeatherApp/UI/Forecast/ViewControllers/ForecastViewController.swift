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
    private let dataSettingsViewHeight: CGFloat = 80

    private let controller: ForecastControllerProtocol
    private let scrollView: UIScrollView
    private let dataSettingsView: ForecastSwitchDataView

    private var loadingViewController: LoadingViewController
    private var forecastChildViewControllers: [UIViewController] = []
    private var localModeEnabled: Bool = false


    // MARK: - Initialization

    init(controller : ForecastControllerProtocol) {
        self.controller = controller
        self.scrollView = UIScrollView()

        self.loadingViewController = LoadingViewController()
        self.loadingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.dataSettingsView = ForecastSwitchDataView.fromNib()

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

        setupSettingsView()
        loadForecastData()
    }

    // MARK: - Private helpers

    private func setupSettingsView() {
        dataSettingsView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(dataSettingsView)
        NSLayoutConstraint.activate([
            dataSettingsView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            dataSettingsView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            dataSettingsView.heightAnchor.constraint(equalToConstant: dataSettingsViewHeight),
            dataSettingsView.widthAnchor.constraint(equalToConstant: view.bounds.width)
        ])
        
        dataSettingsView.delegate = self
    }

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
        controller.fetchWeatherForecast(useLocalStorage: localModeEnabled) { [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.setupForecastWeatherViews()
                    self.configureLoadingViewController(isVisible: false)
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    self.configureLoadingViewController(isVisible: false)
                    self.handleError(error: error)
                }
            }
        }
    }

    private func setupForecastWeatherViews() {
        var currentTopAnchor = dataSettingsView.bottomAnchor

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

    private func handleError(error: Error) {
        var title: String {
            switch error {
            case ForecastError.invalidLocalPath:
                return NSLocalizedString("forecast.error.ivalid.local.file.path", comment: "")
            case ForecastError.invalidRemoteData:
                return NSLocalizedString("forecast.error.fail.remote.parse", comment: "")
            default:
                return ""
            }
        }

        let allert = UIAlertController(title: NSLocalizedString("forecast.alert.error.title", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
        allert.addAction(UIAlertAction(title: NSLocalizedString("forecast.alert.button.text", comment: ""), style: .cancel, handler: nil))
        present(allert, animated: true, completion: nil)
    }

}

extension ForecastViewController : ForecastSwitchDataViewDelegate {

    func switchControlDidChangeWithValue(useLocal: Bool) {
        localModeEnabled = useLocal
        clearView()
        loadForecastData()
    }

    func showSwitchInfo() {
        let allert = UIAlertController(title: "", message: NSLocalizedString("forecast.alert.inforamation", comment: ""), preferredStyle: .alert)
        allert.addAction(UIAlertAction(title: NSLocalizedString("forecast.alert.button.text", comment: ""), style: .cancel, handler: nil))
        present(allert, animated: true, completion: nil)
    }

}

