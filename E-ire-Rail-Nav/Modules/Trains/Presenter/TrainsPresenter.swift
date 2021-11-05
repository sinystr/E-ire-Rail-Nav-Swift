//
//  TrainsPresenter.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 1.11.21.
//

import Foundation

class TrainsPresenter:TrainsPresenterProtocol, TrainsInteractorOutputProtocol
{
    private unowned var view:TrainsViewProtocol!
    private var interactor:TrainsInteractorInputProtocol
    private var router:TrainsRouterProtocol
    private var entity:Any
    
    required init(withInterface view: TrainsViewProtocol, interactor: TrainsInteractorInputProtocol, router: TrainsRouterProtocol, entity: Any) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.entity = entity
    }
    
    func viewDidLoad() {
        if entity is StationModel {
            self.interactor.retrieveTrainsForStation(station: entity as! StationModel)
        } else if entity is RouteModel {
            self.interactor.retrieveTrainsForRoute(route: entity as! RouteModel)
        }
        view.showLoadingIndicator()
    }
    
    func trainsRetrieved(trains: [TrainModel]?, forStation station: StationModel, error: Error?) {
        view.hideLoadingIndicator()
        
        if(error != nil){
            // Error handling
            return
        }
        
        // No trains received
        if(trains == nil){
            view.setupHeadlineForStation(station: station)
            return
        }
        
        view.setupHeadlineForStation(station: station)
        view.showTrains(trains: trains!)
    }
    
    func trainsRetrieved(trains: [TrainModel]?, forRoute route: RouteModel, error: Error?) {
        view.hideLoadingIndicator()
        
        if(error != nil){
            // Error handling
            return
        }
        
        // No trains retrieved
        if(trains == nil){
            view.setupHeadlineForRoute(route: route)
            return
        }

        view.setupHeadlineForRoute(route: route)
        view.showTrains(trains: trains!)
    }
}
