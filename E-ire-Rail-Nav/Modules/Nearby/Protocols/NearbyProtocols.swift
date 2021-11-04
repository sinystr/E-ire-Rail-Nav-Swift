//
//  File.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 23.10.21.
//

import Foundation
import UIKit

// VIEW
protocol NearbyViewProtocol:AnyObject
{
    func showLoadingIndicator()
    func hideLoadingIndicator()
    // PRESENTER -> VIEW
    func showNearbyRoutes(routes:[RouteModel], andStations stations:[StationModel])
    func showAllRoutes(routes:[RouteModel])
    func showAllStations(stations:[StationModel])
    // USER ACTIONS
    func addRouteAction()
    func showAllRoutesAction()
    func showAllStationsAction()
    func showNearbyRoutesAndStationsAction()
    func showRouteDetailsAction(route:RouteModel)
    func showStationDetailsAction(station:StationModel)
}

protocol NearbyEntitiesViewProtocol:AnyObject
{
    func showAllRoutes(routes:[RouteModel])
    func showAllStations(stations:[StationModel])
    func showNearbyRoutes(routes:[RouteModel], andStations stations:[StationModel])
}

// PRESENTER
protocol NearbyPresenterProtocol:AnyObject
{
    func addRouteAction()
    func showAllRoutesAction()
    func showAllStationsAction()
    func showNearbyRoutesAndStationsAction()
    func showRouteDetailsAction(route:RouteModel)
    func showStationDetailsAction(station:StationModel)
}

// INTERACTOR INPUT
protocol NearbyInteractorInputProtocol:AnyObject
{
    func retrieveNearbyRoutesAndStations()
    func retrieveAllStations()
    func retrieveAllRoutes()
}

// INTERACTOR OUTPUT
protocol NearbyInteractorOutputProtocol:AnyObject
{
    func nearbyRoutesAndStationsRetrieved(stations:[StationModel]?, routes:[RouteModel]?, error:Error?)
    func allStationsRetrieved(stations:[StationModel]?, error:Error?)
    func allRoutesRetrieved(routes:[RouteModel]?, error:Error?)
}

// ROUTER
protocol NearbyRouterProtocol:AnyObject
{
    static func createNearbyModule() -> UIViewController
    func presentAddRouteScreenFromView(view:NearbyViewProtocol)
    func presentTrainsScreenForStation(station:StationModel, fromView view:NearbyViewProtocol)
    func presentTrainsScreenForRoute(route:RouteModel, fromView view:NearbyViewProtocol)
}
