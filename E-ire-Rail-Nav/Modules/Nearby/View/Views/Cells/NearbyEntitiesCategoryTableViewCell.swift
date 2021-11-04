//
//  NearbyEntitiesCategoryTableViewCell.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 26.10.21.
//

import Foundation
import UIKit

class NearbyEntitiesCategoryTableViewCell:UITableViewCell
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    weak var nearbyView:NearbyViewProtocol?
    
    @IBAction func addEntityAction(_ sender: Any) {
        nearbyView!.addRouteAction()
    }
    
}
