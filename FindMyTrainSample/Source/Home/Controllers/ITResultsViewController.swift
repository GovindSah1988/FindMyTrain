//
//  ITResultsViewController.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 31/03/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

class ITResultsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultsLB: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var resultInteractor: ITResultsInteractor?
    var sourceStation: ITStation!
    var destinationStation: ITStation!
    
    class func resultsViewController() -> ITResultsViewController {
        let storyboard = UIStoryboard.mainStoryboard()
        let resultsViewController = storyboard.instantiateViewController(withIdentifier: ITConstants.ITViewIdentifiers.resultVC) as! ITResultsViewController
        return resultsViewController
    }

    override func viewDidLoad() {
        tableView.isHidden = true
        activityIndicator.startAnimating()
        resultInteractor = ITResultsInteractor(delegate: self, sourceStation: sourceStation, destinationStation: destinationStation)
        resultInteractor?.fetchTrains()
    }
}

extension ITResultsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultInteractor?.numberOfTrains() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ITConstants.ITViewIdentifiers.resultsTVC, for: indexPath)
        if let train = resultInteractor?.train(at: indexPath.row) {
            (cell as? ITResultTableViewCell)?.configure(with: train)
        }
        
        return cell
    }
    
}

extension ITResultsViewController: ITResultsInteractorOutput {
    
    func trains(trains: [ITTrain]?, error: ITError?) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            if nil == error {
                if trains?.count ?? 0 > 0 {
                    self?.tableView.isHidden = false
                    self?.noResultsLB.isHidden = true
                    self?.tableView.reloadData()
                } else {
                    self?.tableView.isHidden = true
                    self?.noResultsLB.isHidden = false
                    if let source = self?.sourceStation.name, let destination = self?.destinationStation.name {
                        self?.noResultsLB.text = ITConstants.ITLocalizedStringConstants.noTrainsInfo +
                            source.capitalized + ITConstants.ITLocalizedStringConstants.andWithLeadingTrailingSpace + destination.capitalized
                    }
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
