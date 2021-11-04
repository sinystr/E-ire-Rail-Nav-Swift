//
//  XMLStationsParser.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 25.10.21.
//

import Foundation

class XMLStationsParser:NSObject, XMLStationsParserProtocol, XMLParserDelegate
{
    
    private var xmlParser:XMLParser?
    private var stations:[StationModel]?
    private var station:StationModel?
    private var currentElement:String?
    private var completionHandler:(([StationModel]?, Error?) -> Void)?
    
    func parseStationsFrom(data: Data, completionHandler:@escaping ([StationModel]?, Error?) -> Void) {
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
        stations = [StationModel]()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName

        if(elementName == "objStation"){
            station = StationModel()
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName == "objStation"){
            stations!.append(station!)
            station = nil
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmedString = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if(trimmedString.isEmpty){
            return
        }
        
        if(currentElement == "StationDesc"){
            self.station!.name = trimmedString
        }
        
        if(currentElement == "StationLatitude"){
            self.station!.latitude = Double(trimmedString)
        }
        
        if(currentElement == "StationLongitude"){
            self.station!.longitude = Double(trimmedString)
        }
    }
    
    // MARK: Completion methods
    func parserDidEndDocument(_ parser: XMLParser) {
        completionHandler!(stations, nil)
        clearState()
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        completionHandler!(nil, parseError)
        clearState()
    }
    
    func clearState (){
        xmlParser = nil
        stations = nil
        station = nil
        currentElement = nil
        completionHandler = nil
    }
    
}
