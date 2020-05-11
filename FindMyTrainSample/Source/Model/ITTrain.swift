//
//  ITTrain.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 31/03/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

struct ITTrain: Codable {
    var code: String? = nil
    var source: String? = nil
    var destination: String? = nil
    var expectedArrivalTime: String? = nil
    var expectedDepartureTime: String? = nil
}
