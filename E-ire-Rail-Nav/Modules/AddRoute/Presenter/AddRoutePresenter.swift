//
//  AddRoutePresenter.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 31.10.21.
//

import Foundation

class AddRoutePresenter:AddRoutePresenterProtocol, AddRouteInteractorOutputProtocol
{
    weak var view:AddRouteViewProtocol!
    var interactor:AddRouteInteractorInputProtocol
    var router:AddRouteRouterProtocol
    
    init(withView view:AddRouteViewProtocol, interactor:AddRouteInteractorInputProtocol, router:AddRouteRouterProtocol){
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        self.interactor.retrieveAllStations()
        self.view.showLoadingIndicator()
    }
    
    func allStationsRetrieved(stations: [StationModel]?, error: Error?) {
        if(error != nil){
            print("error handling")
            return
        }
        self.view.hideLoadingIndicator()
        self.view.setupViewWithStations(stations: sortStationByName(stations: stations!))
    }
    
    func routeAdded(error: Error?) {
        if(error != nil){
            print("error handling")
            return
        }

        self.view.hideLoadingIndicator()
        self.view.showSuccessMessageAndDismiss()
    }
    
    func addRouteWith(fromStation: String, toStation: String, bidirectional: Bool) {
        self.interactor.addRouteWith(fromStation: fromStation, toStation: toStation, bidirectional: bidirectional)
    }
    
    func sortStationByName(stations:[StationModel]) -> [StationModel]
    {
        return stations.sorted {$0.name! < $1.name!}
    }
    
}
