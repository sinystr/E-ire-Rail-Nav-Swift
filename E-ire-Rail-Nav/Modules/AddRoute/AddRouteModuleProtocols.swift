//
//  AddRouteModuleProtocols.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 31.10.21.
//

import Foundation
import UIKit

// VIEW
protocol AddRouteViewProtocol:AnyObject
{
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showSuccessMessageAndDismiss()
    func setupViewWithStations(stations:[StationModel])
}

// PRESENTER
protocol AddRoutePresenterProtocol:AnyObject
{
    func viewDidLoad()
    func addRouteWith(fromStation:String, toStation:String, bidirectional:Bool)
}

// INTERACTOR INPUT
protocol AddRouteInteractorInputProtocol:AnyObject
{
    func retrieveAllStations()
    func addRouteWith(fromStation:String, toStation:String, bidirectional:Bool)
}

// INTERACTOR OUTPUT
protocol AddRouteInteractorOutputProtocol:AnyObject
{
    func routeAdded(error:Error?)
    func allStationsRetrieved(stations:[StationModel]?, error:Error?)
}

// ROUTER
protocol AddRouteRouterProtocol:AnyObject {
    static func createAddRouteModule() -> UIViewController
}
