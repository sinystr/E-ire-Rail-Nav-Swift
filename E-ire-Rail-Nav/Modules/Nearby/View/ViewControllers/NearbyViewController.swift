import FloatingPanel
import Foundation
import MapKit
import UIKit
import JGProgressHUD

@objc class NearbyViewController: UIViewController, FloatingPanelControllerDelegate, NearbyViewProtocol {
    @IBOutlet var mapView: MKMapView!
    private let nearbyDistance: CLLocationDistance = 20000
    private let irelandMapDistance: CLLocationDistance = 400000
    var loadingIndicator:JGProgressHUD?

    public var presenter: NearbyPresenterProtocol!
    private var nearbyEntitiesView: NearbyEntitiesViewProtocol!
    private var fpc: FloatingPanelController!

    override func viewDidLoad() {
        fpc = FloatingPanelController()
        fpc.surfaceView.backgroundColor = UIColor.clear
        fpc.delegate = self
        let nearbyEntitiesViewController = NearbyEntitiesViewController(nibName: "NearbyEntitiesViewController", bundle: nil)
        nearbyEntitiesViewController.nearbyView = self
        fpc.set(contentViewController: nearbyEntitiesViewController)
        fpc.track(scrollView: nearbyEntitiesViewController.tableView!)
        nearbyEntitiesView = nearbyEntitiesViewController
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        fpc.addPanel(toParent: self)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fpc?.removePanelFromParent(animated: false)
    }

    func showOnMap(stations: [StationModel]) {
        for station in stations {
            let annotation = MKPointAnnotation()
            annotation.title = station.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: station.latitude!, longitude: station.longitude!)
            mapView.addAnnotation(annotation)
        }
    }

    func showNearbyMap(){
        let location = LocationManager.currentLocation
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                        latitudinalMeters: nearbyDistance, longitudinalMeters: nearbyDistance)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func showIrelandMap(){
        let location = CLLocation(latitude: 52.3623828, longitude: -7.8074785)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                        latitudinalMeters: irelandMapDistance, longitudinalMeters: irelandMapDistance)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func showLoadingIndicator() {
        loadingIndicator = JGProgressHUD(style: .extraLight)
        loadingIndicator!.textLabel.text = "Loading"
        loadingIndicator!.show(in: self.view)
    }

    func hideLoadingIndicator() {
        loadingIndicator?.dismiss()
    }

    // MARK: Display data methods

    func showNearbyRoutes(routes: [RouteModel], andStations stations: [StationModel]) {
        nearbyEntitiesView.showNearbyRoutes(routes: routes, andStations: stations)
        showOnMap(stations: stations)
        showNearbyMap();
    }

    func showAllRoutes(routes: [RouteModel]) {
        nearbyEntitiesView.showAllRoutes(routes: routes)
    }

    func showAllStations(stations: [StationModel]) {
        showOnMap(stations: stations)
        showIrelandMap()
        nearbyEntitiesView.showAllStations(stations: stations)
    }

    // MARK: Actions

    func showAllRoutesAction() {
        presenter.showAllRoutesAction()
    }

    func showAllStationsAction() {
        presenter.showAllStationsAction()
    }

    func addRouteAction() {
        presenter.addRouteAction()
    }

    func showRouteDetailsAction(route: RouteModel) {
        presenter.showRouteDetailsAction(route: route)
    }

    func showStationDetailsAction(station: StationModel) {
        presenter.showStationDetailsAction(station: station)
    }

    func showNearbyRoutesAndStationsAction() {
        presenter.showNearbyRoutesAndStationsAction()
    }
}
