//
//  ITHomeViewController.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 31/03/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

let maxItemToShow = 5
let heightOfEachItem = 30

class ITHomeViewController: UIViewController {

    @IBOutlet weak var sourceStationTF: UITextField!
    @IBOutlet weak var destinationStationTF: UITextField!
    @IBOutlet weak var containerView: UIView!
    
    var sourceStation: ITStation?
    var destinationStation: ITStation?
    var activeTextField: UITextField?
    var searchStationView: UIView?
    var searchStationViewController: ITStationTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        sourceStationTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        destinationStationTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func searchTrains(_ sender: Any) {
        
        guard nil != sourceStation, nil != destinationStation else {
            var message = ITConstants.ITLocalizedStringConstants.missingStationDetails
            if (sourceStationTF.text?.count ?? 0 > 0) || (destinationStationTF.text?.count ?? 0) > 0 {
                message = ITConstants.ITLocalizedStringConstants.invalidStationInfo
            }
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: ITConstants.ITLocalizedStringConstants.alertOk, style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        let resultsVC = ITResultsViewController.resultsViewController()
        resultsVC.sourceStation = sourceStation
        resultsVC.destinationStation = destinationStation
        self.navigationController?.pushViewController(resultsVC, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text
        searchStationViewController?.searchStationText = text
    }

}

extension ITHomeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        // for setting up searchView for showing the results for the text
        setupSearchView()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField?.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeTextField?.resignFirstResponder()
        return true
    }
    
    private func setupSearchView() {
        guard let activeTextField = activeTextField else {
            return
        }
        searchStationViewController = ITStationTableViewController.searchStationViewController()
        searchStationViewController?.delegate = self
        guard let searchStationViewController = searchStationViewController else {
            return
        }
        
        searchStationView = searchStationViewController.view
        guard let searchStationView = searchStationView else {
            return
        }
        
        // setting the frame to same width as the text field but with height = 0
        searchStationView.frame = CGRect(origin: CGPoint(x: activeTextField.frame.origin.x, y: (activeTextField.frame.maxY) + 2), size: CGSize(width: activeTextField.frame.width, height: 0))
        
        searchStationView.layer.borderWidth = 1.0
        searchStationView.layer.cornerRadius = 5.0
        searchStationView.layer.borderColor = UIColor.red.cgColor
        
        containerView.addSubview(searchStationView)
    }
    
    private func resetTextField() {
        activeTextField?.resignFirstResponder()
        activeTextField = nil
        searchStationView?.removeFromSuperview()
        searchStationView = nil
        searchStationViewController = nil
    }
}

extension ITHomeViewController: ITStationTableViewControllerDelegate {
    
    func didSelectStation(station: ITStation) {
        switch activeTextField {
        case sourceStationTF:
            sourceStation = station
            break
        case destinationStationTF:
            destinationStation = station
            break
        default:
            return
        }
        activeTextField?.text = station.nameWithCode()
        resetTextField()
    }
    
    func didFetchResults(stations: [ITStation]?) {
        var maxHeight = heightOfEachItem * maxItemToShow
        if stations?.count ?? 0 < maxItemToShow {
            maxHeight = (stations?.count ?? 0) * heightOfEachItem
        }
        searchStationView?.frame.size.height = CGFloat(maxHeight)
    }
}
