//
//  ITResultsInteractor.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 31/03/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

protocol ITResultsInteractorOutput: class {
    func trains(trains: [ITTrain]?, error: ITError?)
}

/**
 Protocol that defines the Interactor's use case.
 */
protocol ITResultsInteractorInput: class {
    func fetchTrains()
    func numberOfTrains() -> Int
    func train(at index: Int) -> ITTrain?
}

class ITResultsInteractor: NSObject {
    
    // to hold the list of API manager objects
    // in case we need to cancel thme at later point of time
    private var managers: NSMutableArray = []
    
    weak var output: ITResultsInteractorOutput!
    let sourceStation: ITStation!
    let destinationStation: ITStation!
    
    // used while parsing the XML
    private var xmlParser: XMLParser?
    private var foundValue: NSMutableString?
    private var trains: [ITTrain]?
    private var currentTrain: ITTrain?
    private var currentElement: String?
    private var error: ITError? = nil
    
    init(delegate: ITResultsInteractorOutput!, sourceStation: ITStation!, destinationStation: ITStation!) {
        output = delegate
        self.sourceStation = sourceStation
        self.destinationStation = destinationStation
    }
    
}

extension ITResultsInteractor: ITResultsInteractorInput {
    
    func fetchTrains() {
        cancelOutstandingRequests()
        let request = ITHomeRequest.getTrains(source: sourceStation)
        let apiManager = ITAPIManager()
        managers.add(apiManager)
        apiManager.executeRequest(request: request) { [weak self] (response, error) in
            if nil == error, nil != response {
                
                // parse the XML data to fetch the trains
                guard let data = response?.data else { return }
                self?.xmlParser = XMLParser(data: data)
                self?.xmlParser?.delegate = self
                self?.foundValue = NSMutableString()
                self?.xmlParser?.parse()
                
            } else {
                //TODO: handle error cases
                self?.output.trains(trains: nil, error: ITError.unknown)
            }
            self?.managers.remove(apiManager)
        }
    }
    
    func numberOfTrains() -> Int {
        return trains?.count ?? 0
    }
    
    func train(at index: Int) -> ITTrain? {
        guard let trains = trains, trains.count > 0 else {
            return nil
        }
        return trains[index]
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
extension ITResultsInteractor: XMLParserDelegate {
    func parserDidStartDocument(_ parser: XMLParser) {
        trains = [ITTrain]()
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        // pass back the trains
        // filter the trains which has the destination as destination source
        if let trains = trains, trains.count > 0 {
            let filteredTrains = trains.filter { ($0.destination == destinationStation.name) }
            output.trains(trains: filteredTrains, error: nil)
        } else {
            output.trains(trains: nil, error: error)
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        // error occurred while parsing
        error = ITError.parserError
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == ITNetworkConstants.ArrayOfObjStationDataKeys.root {
            currentTrain = ITTrain()
        }
        
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == ITNetworkConstants.ArrayOfObjStationDataKeys.root {
            if let currentTrain = currentTrain {
                trains?.append(currentTrain)
            }
            currentTrain = ITTrain()
        } else if elementName == ITNetworkConstants.ArrayOfObjStationDataKeys.code {
            currentTrain?.code = (foundValue as String?)?.trailingSpacesTrimmed()
        } else if elementName == ITNetworkConstants.ArrayOfObjStationDataKeys.source {
            currentTrain?.source = (foundValue as String?)?.trailingSpacesTrimmed()
        } else if elementName == ITNetworkConstants.ArrayOfObjStationDataKeys.destination {
            currentTrain?.destination = (foundValue as String?)?.trailingSpacesTrimmed()
        } else if elementName == ITNetworkConstants.ArrayOfObjStationDataKeys.expectedArrival {
            currentTrain?.expectedArrivalTime = (foundValue as String?)?.trailingSpacesTrimmed()
        } else if elementName == ITNetworkConstants.ArrayOfObjStationDataKeys.expectedDeparture {
            currentTrain?.expectedDepartureTime = (foundValue as String?)?.trailingSpacesTrimmed()
        }
        
        currentElement = nil
        foundValue = NSMutableString()
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if currentElement == ITNetworkConstants.ArrayOfObjStationDataKeys.code || currentElement == ITNetworkConstants.ArrayOfObjStationDataKeys.source || currentElement == ITNetworkConstants.ArrayOfObjStationDataKeys.destination || currentElement == ITNetworkConstants.ArrayOfObjStationDataKeys.expectedArrival || currentElement == ITNetworkConstants.ArrayOfObjStationDataKeys.expectedDeparture {
            foundValue?.append(string)
        }
    }
}
