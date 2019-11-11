//
//  ForecastSwitchDataView.swift
//  GMXWeatherApp
//
//  Created by Vitalii Ianchuk on 11/6/19.
//  Copyright © 2019 Vitalii Ianchuk. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

protocol ForecastSwitchDataViewDelegate : class {

    /// Indicate that was changed remode/local data loading
    /// - Parameter useLocal: is local data used
    func switchControlDidChangeWithValue(useLocal: Bool)

    /// Present general inforamtion
    func showSwitchInfo()

}

final class ForecastSwitchDataView : UIView {

    // MARK: - IBOutlets

    @IBOutlet weak private var localDataLabel: UILabel!
    @IBOutlet weak private var remoteDataLabel: UILabel!
    @IBOutlet weak private var switchControl: UISwitch!

    // MARK: - Properties

    weak var delegate: ForecastSwitchDataViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        localDataLabel.text = NSLocalizedString("forecast.switch.local.text", comment: "")
        remoteDataLabel.text = NSLocalizedString("forecast.switch.remote.text", comment: "")
    }

    // MARK: - Actions

    @IBAction func switchValueChanged(_ sender: UISwitch) {
        delegate?.switchControlDidChangeWithValue(useLocal: !sender.isOn)
    }

    @IBAction func infoButtomAction(_ sender: UIButton) {
        delegate?.showSwitchInfo()
    }
}
