//
//  ITNetworkAgentTests.swift
//  FindMyTrainSampleTests
//
//  Created by Govind Sah on 01/04/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import XCTest
@testable import FindMyTrainSample

/// The MockURLSession acts like a URLSession
class ITMockURLSession: ITURLSessionProtocol {
    
    // for exposing lastURL only as a getter,
    // can be still accessed as public
    private (set) var lastURL: URL?
    
    var currentDataTask = ITMockURLSessionDataTask()
    var responseData: Data?
    var error: Error?
    
    func successHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }

    func dataTask(with request: URLRequest, completion: DataTaskResult) -> ITURLSessionDataTaskProtocol {
        lastURL = request.url
        completion(responseData, successHttpURLResponse(request: request), error)
        return currentDataTask
    }
}

/**In URLSession, the return value must be a URLSessionDataTask.
 However, the URLSessionDataTask can’t be created programmatically,
 thus, this is an object that needs to be mocked
 */
class ITMockURLSessionDataTask: ITURLSessionDataTaskProtocol {
    
    private (set) var isResumed = false
    private (set) var isCancelled = false
    
    func cancel() {
        isCancelled = true
    }
    
    func resume() {
        isResumed = true
    }
}

class ITNetworkAgentTests: XCTestCase {

    var networkAgent: ITNetworkAgent!
    let session = ITMockURLSession()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        networkAgent = ITNetworkAgent(session: session)
    }

    /// for testing whether the network agent sends the same url for making the request as intended
    func test_getTrains_request_url() {
        let sourceStation = ITStation(code: "BRAY", id: nil, name: "BRAY", alternateName: nil, location: nil)
        let request = ITHomeRequest.getTrains(source: sourceStation)
        networkAgent.execute(request: request) { (response, error) in
            
            // Return data
            
            do {
                let requestUrl = try request.asURLRequest().url
                let actualUrl = try response?.request?.asURLRequest().url
                
                // Asserting if the intended request url is different than the actual network request url
                XCTAssert(requestUrl == actualUrl)
                
            } catch {
                
            }

        }
        
        // Asserting if the intended request url is different than the actual network request url
        do {
            let url = try request.asURLRequest().url
            XCTAssert(session.lastURL == url)
        } catch {
            
        }
    }
    
    /// for testing the cancel functionality for any outstanding search request
    func test_cancel_outstanding_getStations_request() {
        
        let dataTask = ITMockURLSessionDataTask()
        session.currentDataTask = dataTask
        
        let searchText = "Bray"
        let request = ITHomeRequest.getStations(searchText: searchText)
        
        networkAgent.execute(request: request) { (response, error) in
            // data
        }
        
        XCTAssert(false == dataTask.isCancelled)
        
        networkAgent.cancelRequest()
        
        XCTAssert(true == dataTask.isCancelled)
    }
    
    /// to test whether the request is actually submitted or not
    func test_get_resume_called() {
        let dataTask = ITMockURLSessionDataTask()
        session.currentDataTask = dataTask
        
        let sourceStation = ITStation(code: "BRAY", id: nil, name: "BRAY", alternateName: nil, location: nil)
        let request = ITHomeRequest.getTrains(source: sourceStation)
        networkAgent.execute(request: request) { (response, error) in
            
        }
        
        XCTAssert(true == dataTask.isResumed)
    }
        
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
