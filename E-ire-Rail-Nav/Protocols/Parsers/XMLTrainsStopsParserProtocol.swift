//
//  XMLTrainsStopsParserProtocol.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 26.10.21.
//

import Foundation

protocol XMLTrainsStopsParserProtocol:AnyObject
{
    func parseTrainStopsFrom(data:Data, completionHandler:@escaping ([String]?, Error?) -> Void)
}
