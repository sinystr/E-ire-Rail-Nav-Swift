//
//  AddRouteInteractor.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 31.10.21.
//

import Foundation

class AddRouteInteractor:AddRouteInteractorInputProtocol
{
    weak var output:AddRouteInteractorOutputProtocol?

    func retrieveAllStations() {
        EntityManager.sharedInstance.getAllStations { stations, error in
            DispatchQueue.main.async {
                self.output?.allStationsRetrieved(stations: stations, error: error)
            }
        }
    }
    
    func addRouteWith(fromStation: String, toStation: String, bidirectional: Bool) {
        EntityManager.sharedInstance.addRouteFromStation(fromStation: fromStation, toStation: toStation, isBidirectional: bidirectional) { error in
            DispatchQueue.main.async {
                self.output?.routeAdded(error: error)
            }
        }
    }
    
}
