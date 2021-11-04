//
//  NearbyRouter.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 24.10.21.
//

import Foundation
import UIKit

class NearbyRouter:NearbyRouterProtocol
{
    static func createNearbyModule() -> UIViewController {
        let nearbyViewController = NearbyViewController.init(nibName: "NearbyViewController", bundle: nil)
        let router = NearbyRouter()
        let interactor = NearbyInteractor()
        let presenter = NearbyPresenter(withView: nearbyViewController, interactor: interactor, router: router)
        nearbyViewController.presenter = presenter
        interactor.output = presenter
        return nearbyViewController
    }
    
    func presentAddRouteScreenFromView(view: NearbyViewProtocol) {
        let viewController = view as! UIViewController
        let addRouteViewController = AddRouteRouter.createAddRouteModule()
        viewController.navigationController?.pushViewController(addRouteViewController, animated: false)
    }
    
    func presentTrainsScreenForStation(station: StationModel, fromView view: NearbyViewProtocol) {
        let viewController = view as! UIViewController
        let stationTrainsViewController = TrainsRouter.createTrainsModuleForEntity(entity: station)
        viewController.navigationController?.pushViewController(stationTrainsViewController, animated: false)
    }
    
    func presentTrainsScreenForRoute(route: RouteModel, fromView view: NearbyViewProtocol) {
        let viewController = view as! UIViewController
        let routeTrainsViewController = TrainsRouter.createTrainsModuleForEntity(entity: route)
        viewController.navigationController?.pushViewController(routeTrainsViewController, animated: false)
    }
    

    
}
