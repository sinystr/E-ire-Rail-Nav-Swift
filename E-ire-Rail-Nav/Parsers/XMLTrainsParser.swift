//
//  XMLTrainsParser.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 25.10.21.
//

import Foundation

class XMLTrainsParser:NSObject, XMLTrainsParserProtocol, XMLParserDelegate
{
    private var xmlParser:XMLParser?
    private var trains:[TrainModel]?
    private var train:TrainModel?
    private var currentElement:String?
    private var completionHandler:(([TrainModel]?, Error?) -> Void)?
    
    func parseTrainsFrom(data: Data, completionHandler: @escaping ([TrainModel]?, Error?) -> Void) {
        xmlParser = XMLParser(data: data)
        xmlParser!.delegate = self
        xmlParser!.shouldProcessNamespaces = false
        xmlParser!.shouldReportNamespacePrefixes = false
        xmlParser!.shouldResolveExternalEntities = false
        self.completionHandler = completionHandler
        xmlParser!.parse()
    }
    
    //MARK: XMLParserDelegate
    func parserDidStartDocument(_ parser: XMLParser) {
        trains = [TrainModel]()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName

        if(elementName == "objStationData"){
            train = TrainModel()
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName == "objStationData"){
            trains!.append(train!)
            train = nil
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmedString = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if(trimmedString.isEmpty){
            return
        }
        
        if(currentElement == "Traincode"){
            self.train!.code = trimmedString
        }
        
        if(currentElement == "Exparrival"){
            self.train!.expectedArrivalTime = trimmedString
        }
        
        if(currentElement == "Expdepart"){
            self.train!.expectedDepartureTime = trimmedString
        }
        
        if(currentElement == "Origin"){
            self.train!.originStationName = trimmedString
        }
        
        if(currentElement == "Destination"){
            self.train!.destinationStationName = trimmedString
        }
    }
    
    // MARK: Completion methods
    func parserDidEndDocument(_ parser: XMLParser) {
        completionHandler!(trains, nil)
        clearState()
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        completionHandler!(nil, parseError)
        clearState()
    }
    
    func clearState (){
        xmlParser = nil
        trains = nil
        train = nil
        currentElement = nil
        completionHandler = nil
    }
    
}
