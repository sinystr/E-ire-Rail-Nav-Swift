import Foundation
import UIKit
import JGProgressHUD

@objc class AddRouteViewController: UIViewController, AddRouteViewProtocol, UIPickerViewDelegate, UIPickerViewDataSource {
    private var stations: [StationModel]?
    public var presenter: AddRoutePresenterProtocol?
    var loadingIndicator:JGProgressHUD?

    @IBOutlet var toStationPickerView: UIPickerView!
    @IBOutlet var fromStationPickerView: UIPickerView!
    @IBOutlet var bidirectionalSwitch: UISwitch!

    override func viewDidLoad() {
        toStationPickerView.delegate = self
        toStationPickerView.dataSource = self
        fromStationPickerView.delegate = self
        fromStationPickerView.dataSource = self
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }

    func showLoadingIndicator() {
        loadingIndicator = JGProgressHUD(style: .extraLight)
        loadingIndicator!.textLabel.text = "Loading"
        loadingIndicator!.show(in: self.view)
    }
    
    func showSuccessMessageAndDismiss() {
        let successHud = JGProgressHUD(style: .extraLight)
        successHud.textLabel.text = "Route added!"
        successHud.indicatorView = JGProgressHUDSuccessIndicatorView()
        successHud.show(in: self.view)
        successHud.dismiss(afterDelay: 3.0)

        let deadlineTime = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func hideLoadingIndicator() {
        self.loadingIndicator?.dismiss()
    }

    func setupViewWithStations(stations: [StationModel]) {
        self.stations = stations
        toStationPickerView.reloadAllComponents()
        fromStationPickerView.reloadAllComponents()
        return
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stations?.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stations?[row].name
    }

    @IBAction func addRouteButtonPressed(_ sender: Any) {
        let fromStation = stations![self.fromStationPickerView.selectedRow(inComponent: 0)].name
        let toStation = stations![self.toStationPickerView.selectedRow(inComponent: 0)].name
        presenter?.addRouteWith(fromStation: fromStation!, toStation: toStation!, bidirectional: bidirectionalSwitch.isOn)
    }
}
