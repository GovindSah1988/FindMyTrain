//
//  ITConstants.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 31/03/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

struct ITConstants {
    
    /// add all the localized constant here
    struct ITLocalizedStringConstants {
        static let invalidStationInfo = "Please enter valid Source & Destination Stations."
        static let missingStationDetails = "Please enter both Source & Destination Stations"
        static let alertOk = "OK"
        static let noTrainsInfo = "No Trains found between "
        static let andWithLeadingTrailingSpace = " and "
        static let commonErrorInfo = "Something Went Wrong. Unable to connect to Server!!"
    }
    
    /// add all the view identifiers here
    struct ITViewIdentifiers {
        static let stationTableVC = "ITStationTableViewController"
        static let searchTVC = "ITSearchTableViewCell"
        static let resultVC = "ITResultsViewController"
        static let resultsTVC = "ITResultTableViewCell"
    }
    
    /// add all the storyboard name here
    struct ITStoryboardConstants {
        static let main = "Main"
    }
}

enum ITError: Error {
    case unknown
    case pathMissing
    case urlMalformed
    case parserError
    case requestCancelled
}

/** Specifies the cache policies used in the app
 - network : The data is directly fetched from the network and cache is updated
 - local   : The data is fetched from the cache (in our case 'Realm')
 */
enum ITCachePolicy: Int {
    case network
    case local
}

enum ITRequestMethod: String {
    case get = "GET"
    case post = "POST"
}
