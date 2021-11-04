//
//  TrainsModuleProtocols.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 1.11.21.
//

import Foundation
import UIKit

// VIEW
protocol TrainsViewProtocol:AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    // PRESENTER -> VIEW
    func setupHeadlineForStation(station:StationModel)
    func setupHeadlineForRoute(route:RouteModel)
    func showTrains(trains:[TrainModel])
}

// INTERACTOR INPUT
protocol TrainsInteractorInputProtocol:AnyObject
{
    func retrieveTrainsForStation(station:StationModel)
    func retrieveTrainsForRoute(route:RouteModel)
}

// INTERACTOR OUTPUT
protocol TrainsInteractorOutputProtocol:AnyObject
{
    func trainsRetrieved(trains:[TrainModel]?, forStation station:StationModel, error:Error?)
    func trainsRetrieved(trains:[TrainModel]?, forRoute route:RouteModel, error:Error?)
}

// ROUTER
protocol TrainsRouterProtocol:AnyObject
{
    static func createTrainsModuleForEntity(entity:Any) -> UIViewController
}

// PRESENTER
protocol TrainsPresenterProtocol:AnyObject
{
    func viewDidLoad()
    init(withInterface view:TrainsViewProtocol,
         interactor:TrainsInteractorInputProtocol,
         router:TrainsRouterProtocol,
         entity:Any)
}
