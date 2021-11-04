//
//  StationModel.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 23.10.21.
//

import Foundation
import CoreLocation

struct StationModel
{
    var name:String? = nil
    var latitude:Double? = nil
    var longitude:Double? = nil
    var location:CLLocation? {
        if let latitude = self.latitude, let longtitude = self.longitude {
            return CLLocation(latitude: latitude, longitude: longtitude)
        }
        return nil
    }
    var distance:Double? = nil
}
