//
//  ITAPIManager.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 31/03/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

class ITAPIManager {
    
    var agent: ITAgentProtocol?
    var cachePolicy: ITCachePolicy?

    func executeRequest(request: ITRequestable, cachePolicy: ITCachePolicy = .network, completion: @escaping (ITResponse?, Error?) -> Void) {
        self.cachePolicy = cachePolicy
        agent = RSAgentFactory.agent(cachePolicy: cachePolicy)
        agent?.execute(request: request, completion: { responseObject, error in
            completion(responseObject, error)
        })
    }

    /// to cancel the ongoing network request
    func cancelRequest() {
        agent?.cancelRequest()
    }
}

class RSAgentFactory {
    static func agent(cachePolicy: ITCachePolicy) -> ITAgentProtocol? {
        switch cachePolicy {
        case .local:
            return nil //Can be used to create ITLocalAgent() in case we have anything to store on db
        case .network:
            return ITNetworkAgent()
        }
    }
}
