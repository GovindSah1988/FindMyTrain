//
//  ITStation.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 31/03/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

struct ITStation {
    var code: String? = nil
    var id: Int? = nil
    var name: String? = nil
    var alternateName: String? = nil
    var location: (latitude: Double, longitude: Double)? = nil
}

extension ITStation {
    func nameWithCode() -> String {
        var nameWithCode = ""
        if let name = self.name {
            if let code = self.code {
                nameWithCode = name + "(" + code + ")"
            } else {
                nameWithCode = name
            }
        }
        return nameWithCode
    }
}
