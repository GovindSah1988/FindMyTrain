//
//  ITEndPoint.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 31/03/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

typealias HeaderParams = [String: String]
typealias APIParams = [String: Any]

/* ITEndpoint protocol defines a set a rules, on conforming to which, a type can
 be classfied as a API request */
protocol ITEndpoint {
    var xml: Bool? { get } // xml response or json response
    var baseURL: String? { get } // base url of the request
    var path: String? { get } // path component of the url
    var method: String? { get } // HTTP Method (e.g. GET, POST etc)
    var headers: HeaderParams? { get } // Header parameters
    var parameters: APIParams? { get } // Request Body/ Query Params
}

extension ITEndpoint {
    internal var xml: Bool? { return true } // xml response or json response
    internal var baseURL: String? { return "" }
    internal var path: String? { return nil }
    internal var method: String? { return ITRequestMethod.get.rawValue }
    internal var headers: HeaderParams? { return [:] }
    internal var parameters: APIParams? { return nil }
}
