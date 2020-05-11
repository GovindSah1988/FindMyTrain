//
//  ITResponse.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 31/03/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

struct ITResponse {
    // MARK: - Properties
    var request: ITRequestable?
    var headerReponse: [AnyHashable: Any]?
    var statusCode: Int?
    var data: Data?
    
    // MARK: - init method
    init(urlResponse: HTTPURLResponse?, request: ITRequestable?, data: Data? = nil) {
        self.request = request
        statusCode = urlResponse?.statusCode
        headerReponse = urlResponse?.allHeaderFields
        self.data = data
    }
}
