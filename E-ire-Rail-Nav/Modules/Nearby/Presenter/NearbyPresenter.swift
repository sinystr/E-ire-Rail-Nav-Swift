//
//  NearbyPresenter.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 24.10.21.
//

import Foundation

class NearbyPresenter:NearbyPresenterProtocol, NearbyInteractorOutputProtocol
{
    unowned var view:NearbyViewProtocol!
    var interactor:NearbyInteractorInputProtocol
    var router:NearbyRouterProtocol
    
    init(withView view:NearbyViewProtocol, interactor:NearbyInteractorInputProtocol, router: NearbyRouterProtocol){
        self.interactor = interactor
        self.view = view
        self.router = router
    }

    func addRouteAction() {
        self.router.presentAddRouteScreenFromView(view: self.view!)
    }
    
    func showAllRoutesAction() {
        self.interactor.retrieveAllRoutes()
    }
    
    func showAllStationsAction() {
        self.view.showLoadingIndicator()
        self.interactor.retrieveAllStations()
    }
    
    func showNearbyRoutesAndStationsAction() {
        self.interactor.retrieveNearbyRoutesAndStations()
        self.view.showLoadingIndicator()
    }
    
    func showRouteDetailsAction(route: RouteModel) {
        self.router.presentTrainsScreenForRoute(route: route, fromView: self.view!)
    }
    
    func showStationDetailsAction(station: StationModel) {
        self.router.presentTrainsScreenForStation(station: station, fromView: self.view!)
    }
    
    func nearbyRoutesAndStationsRetrieved(stations: [StationModel]?, routes: [RouteModel]?, error: Error?) {
        self.view.showNearbyRoutes(routes: routes!, andStations: stations!)
        self.view.hideLoadingIndicator()
    }
    
    func allStationsRetrieved(stations: [StationModel]?, error: Error?) {
        if(error != nil){
            print("error handling")
        }
        
        self.view.showAllStations(stations: stations!)
        self.view.hideLoadingIndicator()
    }
    
    func allRoutesRetrieved(routes: [RouteModel]?, error: Error?) {
        self.view.showAllRoutes(routes: routes!)
        self.view.hideLoadingIndicator()
    }
    
    func sortStationByName(stations:[StationModel]) -> [StationModel]
    {
        return stations.sorted {$0.name! < $1.name!}
    }
}
