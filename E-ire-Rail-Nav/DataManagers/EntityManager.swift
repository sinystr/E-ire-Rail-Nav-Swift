//
//  EntityManager.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 29.10.21.
//

import Foundation

class EntityManager:EntityManagerProtocol
{
    static let sharedInstance = EntityManager()
    let remoteAPI:RemoteDataAPI
    let coreDataIDM:InternalDataManager
    
    private init(){
        remoteAPI = IrishRailRemoteDataAPI()
        coreDataIDM = CoreDataIDM()
    }

    func getAllStations(completionHandler:@escaping ([StationModel]?, Error?) -> Void) {
        coreDataIDM.getAllStations { stations, error in
            // Stations retrieved from Core Data
            if let stations = stations, stations.count > 0 {
                completionHandler(stations, error)
                return
            }
            
            remoteAPI.getAllStations { stationsData, error in
                // Received error
                guard error == nil else {
                    completionHandler(nil, error)
                    return
                }
                
                // Empty data
                guard stationsData != nil else {
                    completionHandler(nil, nil)
                    return
                }
                
                let stationsParser = XMLStationsParser()
                stationsParser.parseStationsFrom(data:stationsData!) { stations, error in
                    // Parse error
                    guard error == nil else {
                        completionHandler(nil, error)
                        return
                    }

                    DispatchQueue.main.async {
                        self.coreDataIDM.saveStations(stations: stations!) { error in
                            // Save to Core Data error
                            guard error == nil else {
                                completionHandler(nil, error)
                                return
                            }
                            completionHandler(stations, nil)
                        }
                    }
                }
                
                
            }
            
        }
    }
    func getAllRoutes(completionHandler:([RouteModel]?, Error?) -> Void) {
        coreDataIDM.getAllRoutes(completionHandler: completionHandler)
    }
    func addRouteFromStation(fromStation:String, toStation:String, isBidirectional:Bool, completionHandler:(Error?) -> Void) {
        coreDataIDM.addRouteFromStation(fromStation: fromStation, toStation: toStation, isBidirectional: isBidirectional, completionHandler: completionHandler)
    }

    func getTrainsForStation(station:StationModel, completionHandler:@escaping ([TrainModel]?, Error?) -> Void) {
        remoteAPI.getTrainsForStation(stationName: station.name!) { trainsData, error in
            // Remote API error
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            // Remote API returned empty response
            guard trainsData != nil else {
                completionHandler(nil, nil)
                return
            }

            let trainsParser = XMLTrainsParser()
            
            trainsParser.parseTrainsFrom(data: trainsData!, completionHandler: completionHandler)
        }
    }

    func getTrainsStops(trainCode:String, completionHandler:@escaping ([String]?, Error?) -> Void) {
        remoteAPI.getTrainStops(trainCode: trainCode) { data, error in
            // Remote API error
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            guard data != nil else {
                // Empty data received
                completionHandler(nil, nil)
                return
            }
            
            let trainStopsParser = XMLTrainsStopsParser()
            trainStopsParser.parseTrainStopsFrom(data: data!, completionHandler: completionHandler)
        }
    }
}
