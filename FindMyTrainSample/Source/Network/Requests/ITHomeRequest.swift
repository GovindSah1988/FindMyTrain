//
//  ITHomeRequest.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 31/03/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

enum ITHomeRequest: ITRequestable {
    case getStations(searchText: String)
    case getTrains(source: ITStation)
    
    var baseURL: String? {
        switch self {
        case .getStations:
            return ITNetworkConstants.APIEndpoints.filterStation
        case .getTrains:
            return ITNetworkConstants.APIEndpoints.allTrains
        }
    }
    
    var parameters: APIParams? {
        switch self {
        case let .getStations(searchText):
            return stationParams(searchText: searchText)
        case let .getTrains(source):
            return trainParams(source: source)
        }
    }

    var method: String? {
        return ITRequestMethod.get.rawValue
    }

}

extension ITHomeRequest {
    
    private func stationParams(searchText: String) -> APIParams {
        var parameters = APIParams()
        parameters[ITNetworkConstants.StationParameterKeys.name] = searchText
        return parameters
    }

    private func trainParams(source: ITStation) -> APIParams {
        var parameters = APIParams()
        if let code = source.code {
            parameters[ITNetworkConstants.StationParameterKeys.stationCode] = code
        }
        return parameters
    }
    
}
