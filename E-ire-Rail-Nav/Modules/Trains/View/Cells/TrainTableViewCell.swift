//
//  TrainTableViewCell.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 1.11.21.
//

import Foundation
import UIKit

class TrainTableViewCell:UITableViewCell
{
    @IBOutlet weak var trainCodeLabel: UILabel!
    @IBOutlet weak var trainOriginDestinationLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    
    func fillWithTrain(train:TrainModel){
        self.trainCodeLabel.text = train.code
        self.trainOriginDestinationLabel.text = "\(train.originStationName!) - \(train.destinationStationName!)"
        self.arrivalTimeLabel.text = "Arrival: \(train.expectedArrivalTime!)"
        self.departureTimeLabel.text = "Departure: \(train.expectedDepartureTime!)"
    }
}
