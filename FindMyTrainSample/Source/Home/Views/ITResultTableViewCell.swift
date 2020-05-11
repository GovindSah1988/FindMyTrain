//
//  ITResultTableViewCell.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 31/03/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

class ITResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var expectedArrivalTimeLB: UILabel!
    @IBOutlet weak var expectedDepartureTimeLB: UILabel!
    @IBOutlet weak var originLB: UILabel!
    @IBOutlet weak var destinationLB: UILabel!

    func configure(with train: ITTrain) {
        nameLB.text = train.code
        expectedArrivalTimeLB.text = train.expectedArrivalTime
        expectedDepartureTimeLB.text = train.expectedDepartureTime
        originLB.text = train.source
        destinationLB.text = train.destination
    }
    
    override func prepareForReuse() {
        nameLB.text = ""
        expectedArrivalTimeLB.text = ""
        expectedDepartureTimeLB.text = ""
        originLB.text = ""
        destinationLB.text = ""
    }
}
