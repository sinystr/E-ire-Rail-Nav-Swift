//
//  InternalDataManagerProtocol.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 27.10.21.
//

import Foundation

protocol InternalDataManager:AnyObject
{
    func saveStations(stations:[StationModel], completionHandler:(Error?)->Void)
    func getAllStations(completionHandler:([StationModel]?, Error?) -> Void)
    func addRouteFromStation(fromStation:String, toStation:String, isBidirectional:Bool, completionHandler:(Error?) -> Void)
    func getAllRoutes(completionHandler:([RouteModel]?, Error?) -> Void)
}
