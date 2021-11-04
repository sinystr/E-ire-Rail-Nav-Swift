//
//  NearbyEntitiesCategoryFooterTableViewCell.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 29.10.21.
//

import UIKit

class NearbyEntitiesCategoryFooterTableViewCell: UITableViewCell {
    @IBOutlet weak var changeViewButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    weak var nearbyView:NearbyViewProtocol?
    private var _isFullListCell:Bool = false
    
    var isFullListCell:Bool {
        set {
            if(newValue){
                changeViewButton.setTitle("Show Nearby view", for: .normal)
            }else{
                changeViewButton.setTitle("See all", for: .normal)
            }
            _isFullListCell = newValue
        }
        get {
            return _isFullListCell
        }
    }
    
    @IBAction func changeView(_ sender: Any) {
        if(isFullListCell){
            nearbyView?.showNearbyRoutesAndStationsAction()
            return
        }
        
        switch(tag){
        case 0:
            nearbyView?.showAllRoutesAction()
        case 1:
            nearbyView?.showAllStationsAction()
        default:
            break
        }
    }
    
    
}
