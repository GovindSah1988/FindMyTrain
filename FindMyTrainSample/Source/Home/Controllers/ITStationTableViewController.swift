//
//  ITStationTableViewController.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 31/03/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

protocol ITStationTableViewControllerDelegate: class {
    func didSelectStation(station: ITStation)
    func didFetchResults(stations: [ITStation]?)
}

class ITStationTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: ITStationTableViewControllerDelegate?

    var searchInteractor: ITStationInteractor?
    var searchStationText: String! {
        didSet {
            searchInteractor?.fetchStations(for: searchStationText)
        }
    }
    
    class func searchStationViewController() -> ITStationTableViewController {
        let storyboard = UIStoryboard.mainStoryboard()
        let searchStationViewController = storyboard.instantiateViewController(withIdentifier: ITConstants.ITViewIdentifiers.stationTableVC) as! ITStationTableViewController
        return searchStationViewController
    }
    
    override func viewDidLoad() {
        searchInteractor = ITStationInteractor(delegate: self)
    }
}

extension ITStationTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchInteractor?.numberOfStations() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ITConstants.ITViewIdentifiers.searchTVC, for: indexPath)
        if let station = searchInteractor?.station(at: indexPath.row) {
            (cell as? ITSearchTableViewCell)?.configure(with: station)
        }
        return cell
    }
    
}

extension ITStationTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let station = searchInteractor?.station(at: indexPath.row) {
            delegate?.didSelectStation(station: station)
        }
    }
}

extension ITStationTableViewController: ITStationInteractorOutput {
    
    func stations(stations: [ITStation]?, error: ITError?) {
        DispatchQueue.main.async { [weak self] in
            if nil == error {
                self?.delegate?.didFetchResults(stations: stations)
                if stations?.count ?? 0 > 0 {
                    self?.tableView.reloadData()
                }
            } else if ITError.requestCancelled == error {
                let alertController = UIAlertController(title: nil, message: ITConstants.ITLocalizedStringConstants.commonErrorInfo, preferredStyle: .alert)
                let okAction = UIAlertAction(title: ITConstants.ITLocalizedStringConstants.alertOk, style: .default)
                alertController.addAction(okAction)
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
