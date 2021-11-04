//
//  TrainsInteractor.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 1.11.21.
//

import Foundation

class TrainsInteractor:TrainsInteractorInputProtocol
{
    weak var output:TrainsInteractorOutputProtocol?

    func retrieveTrainsForStation(station: StationModel) {
        EntityManager.sharedInstance.getTrainsForStation(station: station) { trains, error in
            DispatchQueue.main.async {
                self.output?.trainsRetrieved(trains: trains, forStation: station, error: error)
            }
        }
    }
    
    func retrieveTrainsForRoute(route: RouteModel) {
        EntityManager.sharedInstance.getTrainsForStation(station: route.fromStation) { trains, error in
            if(error != nil || trains == nil){
                self.output?.trainsRetrieved(trains: nil, forRoute: route, error: error)
                return
            }
            
            let group = DispatchGroup()
            let returnTrainsLock = NSLock()
            var returnTrains = [TrainModel]()
            var returnError:Error? = nil
            
            for train in trains! {
                group.enter()
                
                EntityManager.sharedInstance.getTrainsStops(trainCode: train.code!) { stops, error in
                    if(error != nil){
                        returnError = error
                        group.leave()
                        return
                    }
                    
                    var initialStopFound = false
                    
                    for stop in stops! {
                        if (stop == route.fromStation.name)
                        {
                            initialStopFound = true
                            continue
                        }
                        
                        if (stop == route.toStation.name){
                            if(initialStopFound){
                                returnTrainsLock.lock()
                                returnTrains.append(train)
                                returnTrainsLock.unlock()
                            }
                            break
                        }
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main){
                if(returnError != nil)
                {
                    self.output?.trainsRetrieved(trains: nil, forRoute: route, error: returnError)
                    return
                }
                self.output?.trainsRetrieved(trains: returnTrains, forRoute: route, error: nil)
            }
            
        }
    }
    
    
}
