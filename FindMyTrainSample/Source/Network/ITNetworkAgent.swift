//
//  ITNetworkAgent.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 31/03/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

class ITNetworkAgent: ITBaseAgent {
    
    /// It is an object of ITURLSessionDataTaskProtocol -
    /// which must adpot the functionalities of the URLSessionDataTask ultimately.
    var requestTask: ITURLSessionDataTaskProtocol?
}

typealias ITDataResponse = (ITResponse?, Error?) -> Void

extension ITNetworkAgent: ITAgentProtocol {
    
    func execute(request: ITRequestable, completion: @escaping ITDataResponse) {
        
        do {
            let urlRequest = try request.asURLRequest()
            self.requestTask = self.session?.dataTask(with: urlRequest as URLRequest, completion: { data, res, error -> Void in
                if nil !=  error {
                    var error = ITError.unknown
                    if (error as NSError?)?.code == NSURLErrorCancelled {
                        error = ITError.requestCancelled
                    }
                    completion(nil, error)
                } else {
                    guard let data = data else {
                        let response = ITResponse(urlResponse: res as? HTTPURLResponse, request: request)
                        completion(response, ITError.unknown)
                        return
                    }
                    let response = ITResponse(urlResponse: res as? HTTPURLResponse, request: request, data: data)
                    completion(response, nil)
                }
            })
            self.requestTask?.resume()
        } catch {
            
        }
        
    }
    
    func cancelRequest() {
        self.requestTask?.cancel()
    }
}
