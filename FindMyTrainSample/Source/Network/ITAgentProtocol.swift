//
//  ITAgentProtocol.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 31/03/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

protocol ITAgentProtocol {
    func execute(request: ITRequestable, completion: @escaping (ITResponse?, Error?) -> Void)
    func cancelRequest()
}
