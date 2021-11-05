//
//  NearbyInteractor.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 28.10.21.
//

import Foundation

class NearbyInteractor:NearbyInteractorInputProtocol
{
    static let nearbyDistance:Double = 10000
    weak var output:NearbyInteractorOutputProtocol?

    func filterStations(stations:[StationModel], within meters:Double) -> [StationModel]{
        var filteredStations = [StationModel]()
        let currentLocation = LocationManager.currentLocation
        for var station in stations {
            let distance = station.location!.distance(from: currentLocation)
            if(distance < meters) {
                station.distance = distance
                filteredStations.append(station)
            }
        }
        return filteredStations
    }
    
    func filterRoutes(routes:[RouteModel], within meters:Double) -> [RouteModel]{
        var filteredRoutes = [RouteModel]()
        let currentLocation = LocationManager.currentLocation
        for var route in routes {
            let distance = route.fromStation.location!.distance(from: currentLocation)
            if(distance < meters) {
                route.fromStation.distance = distance
                filteredRoutes.append(route)
            }
        }
        return filteredRoutes
    }
    
    func retrieveNearbyRoutesAndStations() {
        EntityManager.sharedInstance.getAllStations { stations, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.output?.nearbyRoutesAndStationsRetrieved(stations: nil, routes: nil, error: error)
                }
                return
            }
            
            EntityManager.sharedInstance.getAllRoutes { routes, error in
                DispatchQueue.main.async {
                    guard error == nil else {
                        DispatchQueue.main.async {
                            self.output?.nearbyRoutesAndStationsRetrieved(stations: nil, routes: nil, error: error)
                        }
                        return
                    }
                    let filteredStations = self.filterStations(stations: stations!, within: NearbyInteractor.nearbyDistance)
                    if(routes != nil){
                        let filteredRoutes = self.filterRoutes(routes: routes!, within: NearbyInteractor.nearbyDistance)
                        self.output?.nearbyRoutesAndStationsRetrieved(stations: filteredStations, routes: filteredRoutes, error: nil)
                    } else {
                        self.output?.nearbyRoutesAndStationsRetrieved(stations: filteredStations, routes: nil, error: nil)
                    }
                    
                }
            }
            
        }
    }
    
    func retrieveAllStations() {
        EntityManager.sharedInstance.getAllStations { stations, error in
            DispatchQueue.main.async {
                if var stations = stations {
                    let currentLocation = LocationManager.currentLocation
                    
                    for (index, _) in stations.enumerated() {
                        stations[index].distance = stations[index].location!.distance(from: currentLocation)
                    }
                    self.output?.allStationsRetrieved(stations: stations, error: error)
                    return
                }
                
                self.output?.allStationsRetrieved(stations: stations, error: error)
            }
        }
    }
    
    func retrieveAllRoutes() {
        EntityManager.sharedInstance.getAllRoutes { routes, error in
            DispatchQueue.main.async {
                if var routes = routes {
                    let currentLocation = LocationManager.currentLocation
                    
                    for (index, _) in routes.enumerated() {
                        routes[index].fromStation.distance = routes[index].fromStation.location!.distance(from: currentLocation)
                    }
                    
                    self.output?.allRoutesRetrieved(routes: routes, error: error)
                    return
                }
                
                self.output?.allRoutesRetrieved(routes: routes, error: error)
            }
        }
    }
    
    
}
