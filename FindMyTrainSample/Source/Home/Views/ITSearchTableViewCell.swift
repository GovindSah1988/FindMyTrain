//
//  ITSearchTableViewCell.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 31/03/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

class ITSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLB: UILabel!
    
    func configure(with station: ITStation) {
        nameLB.text = station.nameWithCode()
    }
    
    override func prepareForReuse() {
        nameLB.text = ""
    }
}
