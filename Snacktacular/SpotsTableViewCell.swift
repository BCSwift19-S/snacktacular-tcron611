//
//  SpotsListTableViewCell.swift
//  Snacktacular
//
//  Created by John Gallaugher on 3/23/18.
//  Copyright © 2018 John Gallaugher. All rights reserved.
//

import UIKit
import CoreLocation

class SpotsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    var currentLocation:CLLocation!
    var spot:Spot!
    
    func configureCell(spot: Spot) {
        nameLabel.text = spot.name
        if spot.averageRating == 0.0 {
            ratingLabel.text = "Avg. Rating: -.-"
        } else {
            ratingLabel.text = "Avg. Rating: " + String(spot.averageRating)
        }
        guard let currentLocation = currentLocation else {
            return
        }
        let distanceInMeters = currentLocation.distance(from: spot.location)
        let distanceString = "Distance: \(( distanceInMeters * 0.00062137).roundTo(places: 2)) miles"
    }
    
    
}
