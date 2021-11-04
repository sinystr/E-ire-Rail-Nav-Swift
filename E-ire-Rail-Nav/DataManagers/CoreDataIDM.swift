//
//  CoreDataIDM.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 27.10.21.
//

import Foundation
import UIKit
import CoreData

class CoreDataIDM:InternalDataManager
{
    func saveStations(stations: [StationModel], completionHandler: (Error?) -> Void) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Station",
                                       in: managedContext)!
        
        for station in stations {
            let stationNSMO = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            stationNSMO.setValue(station.name, forKey: "name")
            stationNSMO.setValue(station.latitude, forKey: "latitude")
            stationNSMO.setValue(station.longitude, forKey: "longitude")
            managedContext.insert(stationNSMO)
        }
        
        do {
            try managedContext.save()
            completionHandler(nil)
        } catch let error {
            completionHandler(error)
        }
    
    }
    
    func getAllStations(completionHandler: ([StationModel]?, Error?) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            var stations = [StationModel]()
            
            for stationNSMO in result as! [NSManagedObject] {
                stations.append(stationFromNSMO(stationNSMO: stationNSMO))
            }
            
            completionHandler(stations, nil)
        } catch let error {
            completionHandler(nil, error)
            return
        }
        
        
        return
    }
    
    func addRouteFromStation(fromStation: String, toStation: String, isBidirectional: Bool, completionHandler: (Error?) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Route",
                                       in: managedContext)!
        
        do {
            let requestFromStation = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
            requestFromStation.predicate = NSPredicate.init(format: "name == %@", fromStation)
            
            let fromStationResults = try managedContext.fetch(requestFromStation)
            
            let requestToStation = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
            requestToStation.predicate = NSPredicate.init(format: "name == %@", toStation)
            
            let toStationResults = try managedContext.fetch(requestToStation)
            
            let routeNSMO = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            routeNSMO.setValue(fromStationResults[0], forKey: "station1")
            routeNSMO.setValue(toStationResults[0], forKey: "station2")
            routeNSMO.setValue(isBidirectional, forKey: "bidirectional")
            
            managedContext.insert(routeNSMO)
            try managedContext.save()
            
            completionHandler(nil)
            
        } catch let error {
            completionHandler(error)
            return
        }
        
        
        return
    }
    
    func getAllRoutes(completionHandler: ([RouteModel]?, Error?) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Route")
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            var routes = [RouteModel]()
            
            for data in result as! [NSManagedObject] {
                let station1 = data.value(forKey: "station1") as! NSManagedObject
                let station2 = data.value(forKey: "station2") as! NSManagedObject
                let fromStationModel = stationFromNSMO(stationNSMO: station1)
                let toStationModel = stationFromNSMO(stationNSMO: station2)
                routes.append(RouteModel(fromStation: fromStationModel, toStation: toStationModel))
                if(data.value(forKey: "bidirectional") as! Bool){
                    routes.append(RouteModel(fromStation: toStationModel, toStation: fromStationModel))
                }
            }
            
            completionHandler(routes, nil)
        } catch let error {
            completionHandler(nil, error)
            return
        }
        return
    }
    
    func stationFromNSMO(stationNSMO:NSManagedObject) -> StationModel
    {
        var station = StationModel()
        station.name = stationNSMO.value(forKey: "name") as? String
        station.latitude = stationNSMO.value(forKey: "latitude") as? Double
        station.longitude = stationNSMO.value(forKey: "longitude") as? Double
        return station
    }
    
}
