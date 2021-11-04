//
//  XMLTrainsParser.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 25.10.21.
//

import Foundation

protocol XMLTrainsParserProtocol:AnyObject
{
    func parseTrainsFrom(data:Data, completionHandler:@escaping ([TrainModel]?, Error?) -> Void)
}
