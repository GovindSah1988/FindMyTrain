//
//  ITStationInteractor.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 31/03/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

protocol ITStationInteractorOutput: class {
    func stations(stations: [ITStation]?, error: ITError?)
}

/**
 Protocol that defines the Interactor's use case.
 */
protocol ITStationInteractorInput: class {
    func fetchStations(for text: String)
    func numberOfStations() -> Int
    func station(at index: Int) -> ITStation?
}

class ITStationInteractor: NSObject {
    
    // to hold the list of API manager objects
    // in case we need to cancel thme at later point of time
    private var managers: NSMutableArray = []
    
    weak var output: ITStationInteractorOutput!
    
    // used while parsing the XML
    private var xmlParser: XMLParser?
    private var foundValue: NSMutableString?
    private var stations: [ITStation]?
    private var currentStation: ITStation?
    private var currentElement: String?
    private var error: ITError? = nil

    init(delegate: ITStationInteractorOutput!) {
        output = delegate
    }
    
}

extension ITStationInteractor: ITStationInteractorInput {
    
    func numberOfStations() -> Int {
        return stations?.count ?? 0
    }
    
    func station(at index: Int) -> ITStation? {
        guard let stations = stations, stations.count > 0 else {
            return nil
        }
        return stations[index]
    }
    
    func fetchStations(for searchText: String) {
        cancelOutstandingRequests()
        let request = ITHomeRequest.getStations(searchText: searchText)
        let apiManager = ITAPIManager()
        managers.add(apiManager)
        apiManager.executeRequest(request: request) { [weak self] (response, error) in
            if nil == error, nil != response {
                
                // parse the XML data to fetch the stations
                guard let data = response?.data else { return }
                self?.xmlParser = XMLParser(data: data)
                self?.xmlParser?.delegate = self
                self?.foundValue = NSMutableString()
                self?.xmlParser?.parse()
                
            } else {
                //TODO: handle error cases
                self?.output.stations(stations: nil, error: ITError.unknown)
            }
            self?.managers.remove(apiManager)
        }
    }

    private func cancelOutstandingRequests() {
        if managers.count > 0 {
            for manager in managers {
                (manager as? ITAPIManager)?.cancelRequest()
            }
            managers.removeAllObjects()
        }
    }
}
extension ITStationInteractor: XMLParserDelegate {
    func parserDidStartDocument(_ parser: XMLParser) {
        stations = [ITStation]()
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        // pass back the stations
        output.stations(stations: stations, error: error)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        // error occurred while parsing
        stations = nil
        error = ITError.parserError
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == ITNetworkConstants.ObjStationFilterKeys.root {
            currentStation = ITStation()
        }
        
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == ITNetworkConstants.ObjStationFilterKeys.root {
            if let currentStation = currentStation {
                stations?.append(currentStation)
            }
            currentStation = ITStation()
        } else if elementName == ITNetworkConstants.ObjStationFilterKeys.code {
            currentStation?.code = (foundValue as String?)?.trailingSpacesTrimmed()
        } else if elementName == ITNetworkConstants.ObjStationFilterKeys.name {
            currentStation?.name = (foundValue as String?)?.trailingSpacesTrimmed()
        }
        
        currentElement = nil
        foundValue = NSMutableString()
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if currentElement == ITNetworkConstants.ObjStationFilterKeys.code || currentElement == ITNetworkConstants.ObjStationFilterKeys.name {
            foundValue?.append(string)
        }
    }
}
