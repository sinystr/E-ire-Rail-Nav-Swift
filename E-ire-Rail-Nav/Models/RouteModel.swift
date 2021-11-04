//
//  RouteModel.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 23.10.21.
//

import Foundation

struct RouteModel
{
    var fromStation:StationModel
    var toStation:StationModel
    var distance:Double? {
        return fromStation.distance
    }
}
