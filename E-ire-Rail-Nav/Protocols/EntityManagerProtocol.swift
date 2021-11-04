//
//  EntityManagerProtocol.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 29.10.21.
//

import Foundation

protocol EntityManagerProtocol:AnyObject
{
    func getAllStations(completionHandler:@escaping([StationModel]?, Error?) -> Void)
    func getAllRoutes(completionHandler:([RouteModel]?, Error?) -> Void)
    func addRouteFromStation(fromStation:String, toStation:String, isBidirectional:Bool, completionHandler:(Error?) -> Void)
    func getTrainsForStation(station:StationModel, completionHandler:@escaping ([TrainModel]?, Error?) -> Void)
    func getTrainsStops(trainCode:String, completionHandler:@escaping ([String]?, Error?) -> Void)
}
