//
//  NearbyEntitiesViewController.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 26.10.21.
//

import Foundation
import UIKit

class NearbyEntitiesViewController:UIViewController, NearbyEntitiesViewProtocol, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    var nearbyView:NearbyViewProtocol!
    private var routes:[RouteModel] = [RouteModel]()
    private var stations:[StationModel] = [StationModel]()
    private var stationsFullListIsShown:Bool = false
    private var routesFullListIsShown:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "NearbyEntityTableViewCell", bundle: nil), forCellReuseIdentifier: "NearbyEntityTableViewCell")
        tableView.register(UINib(nibName: "NearbyEntitiesCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "NearbyEntitiesCategoryTableViewCell")
        tableView.register(UINib(nibName: "NearbyEntitiesCategoryFooterTableViewCell", bundle: nil), forCellReuseIdentifier: "NearbyEntitiesCategoryFooterTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: NearbyEntitiesViewProtocol
    func showAllRoutes(routes: [RouteModel]) {
        self.routes = routes
        routesFullListIsShown = true
        tableView.reloadData()
    }
    
    func showAllStations(stations: [StationModel]) {
        self.stations = stations
        stationsFullListIsShown = true
        tableView.reloadData()
    }
    
    func showNearbyRoutes(routes: [RouteModel], andStations stations: [StationModel]) {
        stationsFullListIsShown = false
        routesFullListIsShown = false
        self.routes = routes
        self.stations = stations
        tableView.reloadData()
    }
    
    
    // MARK: Table View Delegate methods
    
    func distanceStringInKMsFrom(distanceInMeters:Double) -> String {
        return String(format: "%.1f km. away", distanceInMeters / 1000)
    }

    func configureCellForStation(stationIndex:Int, cell:NearbyEntityTableViewCell) -> Void {
        let station = stations[stationIndex]
        cell.entityTypeImageView.image = UIImage(named: "stationIcon")
        cell.entityTypeLabel.text = "Station"
        cell.entityNameLabel.text = station.name
        cell.entityDistanceLabel.text = distanceStringInKMsFrom(distanceInMeters: station.distance!)
    }
    
    func configureCellForRoute(routeIndex:Int, cell:NearbyEntityTableViewCell) -> Void {
        let route = routes[routeIndex]
        cell.entityTypeImageView.image = UIImage(named: "routeIcon")
        cell.entityTypeLabel.text = "Route"
        cell.entityNameLabel.text = "\(route.fromStation.name!) - \(route.toStation.name!)"
        cell.entityDistanceLabel.text = distanceStringInKMsFrom(distanceInMeters: route.distance!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(stationsFullListIsShown){
            return stations.count
        }
        
        if(routesFullListIsShown){
            return routes.count
        }

        return section == 0 ? routes.count : stations.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyEntityTableViewCell") as! NearbyEntityTableViewCell
        
        if(stationsFullListIsShown){
            configureCellForStation(stationIndex: indexPath.row, cell: cell)
            return cell
        }
        
        if(routesFullListIsShown){
            configureCellForRoute(routeIndex: indexPath.row, cell: cell)
            return cell
        }
        
        switch indexPath.section {
        case 0:
            configureCellForRoute(routeIndex: indexPath.row, cell: cell)
        case 1:
            configureCellForStation(stationIndex: indexPath.row, cell: cell)
        default:
            break;
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return stationsFullListIsShown || routesFullListIsShown ? 1 : 2;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "NearbyEntitiesCategoryTableViewCell") as! NearbyEntitiesCategoryTableViewCell
        
        headerCell.nearbyView = self.nearbyView
        
        if(routesFullListIsShown){
            headerCell.titleLabel.text = "All Routes"
            return headerCell
        }
        
        if(stationsFullListIsShown){
            headerCell.titleLabel.text = "All Stations"
            headerCell.addButton.isHidden = true
            return headerCell
        }
        
        switch section {
        case 0:
            headerCell.titleLabel.text = "Routes"
            break
        case 1:
            headerCell.titleLabel.text = "Stations"
            headerCell.addButton.isHidden = true
            break
        default:
            break
        }
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerCell = tableView.dequeueReusableCell(withIdentifier: "NearbyEntitiesCategoryFooterTableViewCell") as! NearbyEntitiesCategoryFooterTableViewCell
        
        if(stationsFullListIsShown || routesFullListIsShown) {
            footerCell.isFullListCell = true
        }
        
        footerCell.nearbyView = self.nearbyView
        footerCell.tag = section

        return footerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(routesFullListIsShown){
            self.nearbyView.showRouteDetailsAction(route: routes[indexPath.row])
            return
        }
        
        if(stationsFullListIsShown){
            self.nearbyView.showStationDetailsAction(station: stations[indexPath.row])
            return
        }
        
        switch(indexPath.section){
        case 0:
            self.nearbyView.showRouteDetailsAction(route: routes[indexPath.row])
            break
        case 1:
            self.nearbyView.showStationDetailsAction(station: stations[indexPath.row])
        default:
            break;
        }
    }
}
