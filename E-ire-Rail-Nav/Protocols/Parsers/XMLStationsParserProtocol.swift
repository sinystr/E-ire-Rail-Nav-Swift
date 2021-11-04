//
//  XMLStationsParser.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 25.10.21.
//

import Foundation

protocol XMLStationsParserProtocol:AnyObject
{
    func parseStationsFrom(data:Data, completionHandler:@escaping ([StationModel]?, Error?) -> Void)
}
