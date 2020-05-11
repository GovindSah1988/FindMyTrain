//
//  ITNetworkConstants.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 31/03/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

struct ITNetworkConstants {

    struct APIEndpoints {
        static let baseurl = "http://api.irishrail.ie/realtime/realtime.asmx"
        
        static let allTrains = baseurl + "/getStationDataByCodeXML"
        static let filterStation = baseurl + "/getStationsFilterXML"
    }
    
    struct StationParameterKeys {
        static let name = "StationText"
        static let stationCode = "StationCode"
    }

    struct ObjStationFilterKeys {
        static let root = "objStationFilter"
        static let name = "StationDesc"
        static let code = "StationCode"
    }
    
    struct ArrayOfObjStationDataKeys {
        static let root = "objStationData"
        static let code = "Traincode"
        static let source = "Origin"
        static let destination = "Destination"
        static let expectedArrival = "Exparrival"
        static let expectedDeparture = "Expdepart"
    }

}
