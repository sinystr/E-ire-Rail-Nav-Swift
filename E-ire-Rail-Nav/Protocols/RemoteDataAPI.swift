//
//  RemoteDataAPI.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 24.10.21.
//

import Foundation

protocol RemoteDataAPI:AnyObject
{
    func getAllStations(completionHandler:@escaping (Data?, Error?)->Void)
    func getTrainsForStation(stationName:String, completionHandler:@escaping (Data?, Error?)->Void)
    func getTrainStops(trainCode:String, completionHandler:@escaping (Data?, Error?)->Void)
}
