//
//  ITRequestTests.swift
//  FindMyTrainSampleTests
//
//  Created by Govind Sah on 01/04/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import XCTest
@testable import FindMyTrainSample

class ITRequestTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    /// to test getStations request
    func test_getStations_home_request() {
        let searchText = "Bray"
        let request = ITHomeRequest.getStations(searchText: searchText)
        do {
            let requestUrl = try request.asURLRequest()
            XCTAssertEqual(requestUrl.url?.absoluteString, "http://api.irishrail.ie/realtime/realtime.asmx/getStationsFilterXML?StationText=" + searchText)
        } catch {
            
        }
    }
    
    /// to test getTrain request
    func test_getTrains_home_request() {
        let source = ITStation(code: "BRAY", id: nil, name: nil, alternateName: nil, location: nil)
        let request = ITHomeRequest.getTrains(source: source)
        do {
            let requestUrl = try request.asURLRequest()
            XCTAssertEqual(requestUrl.url?.absoluteString, "http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByCodeXML?StationCode=" + source.code!)
        } catch {
            
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
