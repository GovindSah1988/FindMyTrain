//
//  ITStringExtensionTests.swift
//  FindMyTrainSampleTests
//
//  Created by Govind Sah on 01/04/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import XCTest
@testable import FindMyTrainSample

class ITStringExtensionTests: XCTestCase {

    var stringUnderTest: String?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_trailingSpacesTrimmed() {
        stringUnderTest = "Test "
        var trimmedString = stringUnderTest?.trailingSpacesTrimmed()
        XCTAssertEqual(trimmedString, "Test")
        
        stringUnderTest = "Test    "
        trimmedString = stringUnderTest?.trailingSpacesTrimmed()
        XCTAssertEqual(trimmedString, "Test")
    }

}
