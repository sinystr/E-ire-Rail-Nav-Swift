//
//  XMLTrainsStopsParser.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 26.10.21.
//

import Foundation

class XMLTrainsStopsParser:NSObject, XMLTrainsStopsParserProtocol, XMLParserDelegate
{
    private var xmlParser:XMLParser?
    private var trainStops:[String]?
    private var currentElement:String?
    private var completionHandler:(([String]?, Error?) -> Void)?
 
    func parseTrainStopsFrom(data: Data, completionHandler: @escaping ([String]?, Error?) -> Void) {
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
        trainStops = [String]()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmedString = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)

        if(trimmedString.isEmpty){
            return
        }

        if(currentElement == "LocationFullName"){
            trainStops!.append(trimmedString)
        }
    }
    
    // MARK: Completion methods
    func parserDidEndDocument(_ parser: XMLParser) {
        completionHandler!(trainStops, nil)
        clearState()
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        completionHandler!(nil, parseError)
        clearState()
    }
    
    func clearState (){
        xmlParser = nil
        trainStops = nil
        currentElement = nil
        completionHandler = nil
    }
    
}
