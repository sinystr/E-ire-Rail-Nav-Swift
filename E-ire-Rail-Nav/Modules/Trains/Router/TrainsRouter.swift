//
//  TrainsRouter.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 1.11.21.
//

import Foundation
import UIKit

class TrainsRouter:TrainsRouterProtocol
{
    static func createTrainsModuleForEntity(entity:Any) -> UIViewController {
        let viewController = TrainsViewController.init(nibName: "TrainsViewController", bundle: nil)
        let interactor = TrainsInteractor()
        let router = TrainsRouter()
        let presenter = TrainsPresenter.init(withInterface: viewController,
                                             interactor: interactor,
                                             router: router,
                                             entity: entity)
        viewController.presenter = presenter
        interactor.output = presenter
        return viewController
    }
    
    
}
