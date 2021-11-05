//
//  TrainsViewController.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 1.11.21.
//

import Foundation
import UIKit
import JGProgressHUD

class TrainsViewController:UIViewController, TrainsViewProtocol, UITableViewDelegate, UITableViewDataSource
{
    var loadingIndicator:JGProgressHUD?
    @IBOutlet weak var entityTitle: UILabel!
    @IBOutlet weak var entityTypeSubtitle: UILabel!
    @IBOutlet weak var entityDistance: UILabel!
    @IBOutlet weak var trainsTableView: UITableView!
    var presenter:TrainsPresenterProtocol!
    var trains:[TrainModel] = [TrainModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trainsTableView.register(UINib.init(nibName: "TrainTableViewCell", bundle: nil), forCellReuseIdentifier: "TrainTableViewCell")
        trainsTableView.delegate = self
        trainsTableView.dataSource = self
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillAppear(animated)
    }
    
    func showLoadingIndicator() {
        loadingIndicator = JGProgressHUD(style: .extraLight)
        loadingIndicator!.textLabel.text = "Loading"
        loadingIndicator!.show(in: self.view)
    }
    
    func hideLoadingIndicator() {
        loadingIndicator?.dismiss()
    }
    
    func distanceStringInKMsFrom(distanceInMeters:Double) -> String {
        return String(format: "%.1f km. away", distanceInMeters / 1000)
    }
    
    func setupHeadlineForStation(station: StationModel) {
        entityTitle.text = station.name
        entityTypeSubtitle.text = "Station"
        entityDistance.text = distanceStringInKMsFrom(distanceInMeters: station.distance!)
    }
    
    func setupHeadlineForRoute(route: RouteModel) {
        entityTitle.text = "\(route.fromStation.name!) - \(route.toStation.name!)"
        entityTypeSubtitle.text = "Route"
        entityDistance.text = distanceStringInKMsFrom(distanceInMeters: route.distance!)
    }
    
    func showTrains(trains: [TrainModel]) {
        self.trains = trains
        trainsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trains.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.trainsTableView.dequeueReusableCell(withIdentifier: "TrainTableViewCell") as! TrainTableViewCell
        cell.selectionStyle = .none
        cell.fillWithTrain(train: trains[indexPath.row])
        return cell
    }
}
