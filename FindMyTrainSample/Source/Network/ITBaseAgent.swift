//
//  ITBaseAgent.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 31/03/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

/// done in order to mock URLSessionDataTask
protocol ITURLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

/// done in order to mock URLSession
protocol ITURLSessionProtocol {
    func dataTask(with request: URLRequest, completion: @escaping DataTaskResult) -> ITURLSessionDataTaskProtocol
}

extension URLSession: ITURLSessionProtocol {
    func dataTask(with request: URLRequest, completion: @escaping DataTaskResult) -> ITURLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completion) as ITURLSessionDataTaskProtocol
    }
}

/// by default URLSessionDataTask has something called resume() method
// so no need to add protocol's method - func resume()
extension URLSessionDataTask: ITURLSessionDataTaskProtocol { }

class ITBaseAgent {
    
    /// It is an object of ITURLSessionProtocol -
    /// which must adpot the functionalities of the URLSession ultimately.
    private (set) var session: ITURLSessionProtocol? // only for exposing the getter for session object
    
    init(session: ITURLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}
