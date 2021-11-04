//
//  AddRouteRouter.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 31.10.21.
//

import Foundation
import UIKit

class AddRouteRouter:AddRouteRouterProtocol
{
    static func createAddRouteModule() -> UIViewController {
        let addRouteViewController = AddRouteViewController.init(nibName: "AddRouteViewController", bundle: nil)
        let interactor = AddRouteInteractor()
        let router = AddRouteRouter()
        let presenter = AddRoutePresenter(withView: addRouteViewController, interactor: interactor, router: router)
        addRouteViewController.presenter = presenter
        interactor.output = presenter
        return addRouteViewController
    }
}
